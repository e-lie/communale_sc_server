#!/usr/bin/env python3
"""
OSC Monitor - Affiche tous les messages OSC reçus sur toutes les interfaces
Usage: python osc_monitor.py <port>
"""

import argparse
import sys
from datetime import datetime
from pythonosc import dispatcher
from pythonosc import osc_server


def handle_osc_message(address, *args):
    """Handler générique pour tous les messages OSC"""
    timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]

    print(f"\n[{timestamp}] OSC Message")
    print(f"  Address: {address}")
    print(f"  Args: {list(args) if args else '(no arguments)'}")


def main():
    # Parser les arguments
    parser = argparse.ArgumentParser(
        description='OSC Monitor - Écoute et affiche tous les messages OSC reçus',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemples:
  python osc_monitor.py 57120        Écoute sur le port 57120
  python osc_monitor.py 8000         Écoute sur le port 8000
        """
    )
    parser.add_argument('port', type=int, help='Port OSC à écouter (1024-65535)')

    args = parser.parse_args()

    # Valider le port
    if args.port < 1024 or args.port > 65535:
        print(f"Erreur: Le port doit être entre 1024 et 65535 (reçu: {args.port})", file=sys.stderr)
        sys.exit(1)

    # Créer le dispatcher avec un handler catch-all
    disp = dispatcher.Dispatcher()
    disp.map("*", handle_osc_message)  # Capture tous les messages

    # Créer le serveur OSC sur toutes les interfaces (0.0.0.0)
    try:
        server = osc_server.BlockingOSCUDPServer(("0.0.0.0", args.port), disp)
        print(f"=== OSC Monitor démarré ===")
        print(f"Écoute sur toutes les interfaces, port {args.port}")
        print(f"Appuyez sur Ctrl+C pour arrêter\n")

        # Démarrer l'écoute
        server.serve_forever()

    except OSError as e:
        if e.errno == 98:  # Address already in use
            print(f"Erreur: Le port {args.port} est déjà utilisé", file=sys.stderr)
        else:
            print(f"Erreur: {e}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\n=== OSC Monitor arrêté ===")
        sys.exit(0)


if __name__ == "__main__":
    main()
