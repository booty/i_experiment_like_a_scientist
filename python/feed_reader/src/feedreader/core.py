# src/feedreader/core.py
import requests
from typing import Any


def process_feed(feed_url: str) -> Any:
    """
    Fetches and processes the feed data from the provided URL.

    Under the hood, this function performs an HTTP GET request to retrieve
    data and then processes it. In a real-world scenario, you might parse XML or JSON.

    :param feed_url: The URL of the feed to process.
    :return: Parsed data from the feed.
    """
    response = requests.get(feed_url)
    response.raise_for_status()  # Raises an HTTPError for bad responses
    # For now, simply return the text. In production, parse as needed.
    return response.text
