#!/usr/bin/env python3
"""Convert all audio samples to mono 44100Hz WAV and delete originals"""

from pydub import AudioSegment
import os
from pathlib import Path

# Configuration
samples_dir = Path("./samples")
target_sample_rate = 44100
target_channels = 1  # mono

print(f"Converting samples in {samples_dir.absolute()}")
print(f"Target: {target_sample_rate}Hz, mono WAV\n")

# Parcourir tous les fichiers audio
audio_extensions = ['.flac', '.mp3', '.wav', '.ogg', '.m4a', '.aac']
converted_count = 0

for audio_file in samples_dir.rglob('*'):
    if audio_file.suffix.lower() in audio_extensions:
        print(f"Processing: {audio_file.relative_to(samples_dir)}")

        try:
            # Charger le fichier audio
            audio = AudioSegment.from_file(str(audio_file))

            # Convertir en mono
            if audio.channels > 1:
                audio = audio.set_channels(target_channels)
                print(f"  → Converted to mono")

            # Convertir le sample rate
            if audio.frame_rate != target_sample_rate:
                audio = audio.set_frame_rate(target_sample_rate)
                print(f"  → Resampled to {target_sample_rate}Hz")

            # Créer le nom du fichier de sortie (même nom, extension .wav)
            output_file = audio_file.with_suffix('.wav')

            # Exporter en WAV
            audio.export(str(output_file), format='wav')
            print(f"  → Saved as: {output_file.name}")

            # Supprimer l'original (seulement si ce n'était pas déjà un .wav)
            if audio_file.suffix.lower() != '.wav':
                audio_file.unlink()
                print(f"  → Deleted original: {audio_file.name}")

            converted_count += 1
            print()

        except Exception as e:
            print(f"  ✗ Error: {e}\n")

print(f"Done! Converted {converted_count} file(s)")
