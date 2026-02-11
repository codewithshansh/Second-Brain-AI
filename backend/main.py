from fastapi import FastAPI
from pydantic import BaseModel
from context_engine import analyze_context
from ai_engine import generate_suggestion

app = FastAPI()


class UserInput(BaseModel):
    location: str
    tasks: list[str]


@app.post("/suggest")
def get_suggestion(user_input: UserInput):
    context = analyze_context(user_input.dict())
    suggestion = generate_suggestion(context)

    return {
        "context": context,
        "suggestion": suggestion
    }
