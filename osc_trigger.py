#!/usr/bin/env python3
"""Simple OSC trigger for SuperCollider FM Synth"""

from pythonosc import udp_client
import time
import random

# Configuration
client = udp_client.SimpleUDPClient("127.0.0.1", 57120)

print("Triggering /fm in loop... (Ctrl+C to stop)\n")

# Boucle infinie avec paramètres variables
while True:
    # Paramètres variables
    # freq = random.choice([220, 247, 277, 330, 370, 440, 494, 554])
    # mod_freq = freq * random.uniform(0.3, 2.0)
    # mod_index = random.uniform(0.5, 4.0)
    # amp = random.uniform(0.1, 0.4)

    # Envoyer le message OSC
    # client.send_message("/jeu1", [freq, mod_freq, mod_index, amp])
    client.send_message("/jeu1")

    # Attendre avant le prochain trigger
    time.sleep(random.uniform(0.3, 1.5))
