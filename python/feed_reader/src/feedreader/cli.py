# src/feedreader/cli.py
import typer
from feedreader.core import process_feed
from typing import Optional

app = typer.Typer(help="FeedReader: A CLI tool to read and process feeds.")


@app.command()
def main(
    feed_url: str,
    verbose: Optional[bool] = typer.Option(False, help="Enable verbose output."),
) -> None:
    """
    Reads a feed from the given URL and processes it.
    """
    if verbose:
        typer.echo("Verbose mode enabled.")
    try:
        data = process_feed(feed_url)
        typer.echo("Feed processed successfully!")
        typer.echo(data)
    except Exception as exc:
        typer.echo(f"Error processing feed: {exc}")
        raise typer.Exit(code=1)


if __name__ == "__main__":
    app()
