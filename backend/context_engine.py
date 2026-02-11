from datetime import datetime


def analyze_context(user_input: dict):
    """
    Takes raw user input and converts it into structured context.
    """

    current_hour = datetime.now().hour

    # Time block detection
    if 5 <= current_hour < 12:
        time_block = "morning"
    elif 12 <= current_hour < 17:
        time_block = "afternoon"
    elif 17 <= current_hour < 22:
        time_block = "evening"
    else:
        time_block = "night"

    # Simulated energy logic
    if time_block in ["morning", "evening"]:
        energy_level = "high"
    else:
        energy_level = "medium"

    # Location (sent from mobile)
    location = user_input.get("location", "unknown")

    # Pending tasks
    tasks = user_input.get("tasks", [])

    context = {
        "time_block": time_block,
        "energy_level": energy_level,
        "location": location,
        "tasks": tasks
    }

    return context
