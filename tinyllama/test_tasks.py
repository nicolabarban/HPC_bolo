import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
import time
import pandas as pd

# Parameters
csv_input_path = "/scratch.hpc/$USER/data/HPC_bolo/tasks.txt"
csv_output_path = "/scratch.hpc/$USER/data/HPC_bolo/output/skills_score.txt"
sample_size = 100
max_new_tokens = 5
model_name = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"

# Load and sample names
df = pd.read_csv(csv_input_path)
df = df.dropna()
sample_size = len(df)
tasks = df["Task"].sample(n=sample_size, random_state=42).tolist()

print(f"Sampled {len(tasks)} taks")

# Load model and tokenizer
print("Loading tokenizer and model...")
start_time = time.time()
tokenizer = AutoTokenizer.from_pretrained(model_name)
tokenizer.padding_side = 'left'
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    device_map="auto"
)
model.eval()
model_load_time = time.time() - start_time
print(f"Loaded model and tokenizer in {model_load_time:.2f} seconds\n")

print(model.device)  # Should be 'cuda' or similar
print(torch.cuda.is_available())  # Should be True

# Prepare prompt formatting
base_prompt = "On a scale from 0 to 100, how likely is it that the following skill can be replaced by AI?: {}"

# Storage for outputs
results = []

# Batched generation (for speed & memory)
batch_size = 16
num_batches = (len(first_names) + batch_size - 1) // batch_size

print(f"Generating task prediction in {num_batches} batches...\n")

# Start timing the entire generation process
generation_start_time = time.time()
batch_times = []

for batch_start in range(0, len(first_names), batch_size):
    batch_start_time = time.time()
    batch_names = first_names[batch_start:batch_start + batch_size]
    formatted_prompts = []

    for name in batch_names:
        prompt_text = base_prompt.format(name)
        messages = [
            {"role": "system", "content": "You are a helpful assistant that guesses On a scale from 0 to 100, how likely is it that the following skill can be replaced by AI?"},
            {"role": "user", "content": prompt_text},
        ]
        prompt = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
        formatted_prompts.append(prompt)

    # Tokenize
    inputs = tokenizer(formatted_prompts, return_tensors="pt", padding=True, truncation=True).to(model.device)

    # Generate
    with torch.inference_mode():
        outputs = model.generate(
            **inputs,
            max_new_tokens=max_new_tokens,
            do_sample=True,
            temperature=0.7,
            top_k=50,
            top_p=0.95,
            pad_token_id=tokenizer.eos_token_id,
            eos_token_id=tokenizer.eos_token_id,
        )

    # Decode outputs
    for name, output_ids in zip(batch_names, outputs):
        input_length = inputs['input_ids'].shape[1]
        generated_ids = output_ids[input_length:]
        generated_text = tokenizer.decode(generated_ids, skip_special_tokens=True).strip()

        results.append({"name": name, "task_guess": generated_text})

    batch_time = time.time() - batch_start_time
    if batch_start > 0:  # Skip first batch for timing
        batch_times.append(batch_time)
    print(f"Processed batch {batch_start // batch_size + 1}/{num_batches} in {batch_time:.2f} seconds")

# Calculate total generation time (excluding first batch)
total_generation_time = sum(batch_times)
print(f"\nTotal generation time (excluding first batch): {total_generation_time:.2f} seconds")
print(f"Average time per batch (excluding first batch): {total_generation_time/len(batch_times):.2f} seconds")
print(f"Average time per request: {total_generation_time/(len(batch_times) * batch_size):.2f} seconds")

# Write results to CSV
results_df = pd.DataFrame(results)
results_df.to_csv(csv_output_path, index=False)
print(f"\nSaved results to {csv_output_path}")

# Print summary of timing
print("\nTiming Summary:")
print(f"Model loading time: {model_load_time:.2f} seconds")
print(f"Total generation time (excluding first batch): {total_generation_time:.2f} seconds")
print(f"Average time per batch (excluding first batch): {total_generation_time/len(batch_times):.2f} seconds")
print(f"Average time per request: {total_generation_time/(len(batch_times) * batch_size):.2f} seconds")
