import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("OPENROUTER_API_KEY")

API_URL = "https://openrouter.ai/api/v1/chat/completions"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}


def query_llm(prompt):
    try:
        response = requests.post(
            API_URL,
            headers=headers,
            json={
                "model": "mistralai/mistral-7b-instruct",
                "messages": [
                    {"role": "system", "content": "You are a smart productivity AI assistant."},
                    {"role": "user", "content": prompt}
                ],
                "max_tokens": 150,
                "temperature": 0.7
            },
            timeout=60
        )

        print("Status Code:", response.status_code)
        print("Response Text:", response.text)

        if response.status_code != 200:
            return "AI service unavailable."

        result = response.json()
        return result["choices"][0]["message"]["content"]

    except Exception as e:
        return f"Error: {str(e)}"


def generate_suggestion(context: dict):
    time_block = context["time_block"]
    energy = context["energy_level"]
    location = context["location"]
    tasks = context["tasks"]

    if not tasks:
        return "You have no pending tasks."

    primary_task = tasks[0]

    prompt = f"""
    Context:
    Time of day: {time_block}
    Energy level: {energy}
    Location: {location}
    Task: {primary_task}

    Give a short productivity suggestion (max 2 sentences).
    """

    return query_llm(prompt)
