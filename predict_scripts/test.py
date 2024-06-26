# Example with batching
num_stories = 10
prompts = ["Once upon a time,"] * num_stories

# batched example, with 10 stories completions per request
response = client.chat.completions.create(
    model="curie",
    prompt=prompts,
    max_tokens=20,
)

# match completions to prompts by index
stories = [""] * len(prompts)
for choice in response.choices:
    stories[choice.index] = prompts[choice.index] + choice.text

# print stories
for story in stories:
    print(story)