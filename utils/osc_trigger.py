#!/usr/bin/env python3
"""Simple OSC trigger for SuperCollider FM Synth"""

from pythonosc import udp_client
import time
import random

# Configuration
client = udp_client.SimpleUDPClient("127.0.0.1", 57120)

print("Triggering /popup in loop... (Ctrl+C to stop)\n")

# Boucle infinie avec paramètres variables
while True:
    # Paramètres variables
    # freq = random.choice([220, 247, 277, 330, 370, 440, 494, 554])
    # mod_freq = freq * random.uniform(0.3, 2.0)
    # mod_index = random.uniform(0.5, 4.0)
    # amp = random.uniform(0.1, 0.4)
    
    retrig = random.choice([1])
    rate = .2
    sample_index = random.choice([1])

    # Envoyer le message OSC
    # client.send_message("/jeu1", [freq, mod_freq, mod_index, amp])
    # params = ["popup", sample_index, retrig, rate]
    params = ["win"]
    client.send_message("/popup", params)
    print("/popup " + str(params))

    # Attendre avant le prochain trigger
    time.sleep(random.uniform(0.03, .05))
