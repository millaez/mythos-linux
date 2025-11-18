#!/usr/bin/env python3
"""
MythOS Provisioner — Modular System Setup
Orchestrates bootstrap, pillars, and profiles for reproducible Arch-based installs.
"""

import argparse
import subprocess
import sys
import yaml
from pathlib import Path
from typing import List, Dict


class MythOSProvisioner:
    def __init__(self, repo_root: Path):
        self.repo_root = repo_root
        self.bootstrap_dir = repo_root / "bootstrap"
        self.pillars_dir = repo_root / "pillars"
        self.profiles_dir = repo_root / "profiles"
        self.traits_dir = repo_root / "traits"

    def run_script(self, script_path: Path, description: str = None):
        """Execute a shell script with error handling."""
        if not script_path.exists():
            print(f"❌ Script not found: {script_path}")
            return False

        desc = description or script_path.name
        print(f"🔧 Running: {desc}")
        
        try:
            result = subprocess.run(
                ["bash", str(script_path)],
                check=True,
                capture_output=True,
                text=True
            )
            print(f"✅ {desc} completed")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ {desc} failed:")
            print(e.stderr)
            return False

    def load_profile(self, profile_name: str) -> Dict:
        """Load a YAML profile configuration."""
        profile_path = self.profiles_dir / f"{profile_name}.yaml"
        
        if not profile_path.exists():
            print(f"❌ Profile not found: {profile_name}")
            sys.exit(1)
        
        with open(profile_path) as f:
            return yaml.safe_load(f)

    def load_trait(self, trait_name: str) -> Dict:
        """Load a reusable trait set."""
        trait_path = self.traits_dir / f"{trait_name}.yaml"
        
        if not trait_path.exists():
            print(f"⚠️  Trait not found: {trait_name}")
            return {}
        
        with open(trait_path) as f:
            return yaml.safe_load(f)

    def bootstrap(self):
        """Run base Arch system setup."""
        print("\n🜁 MythOS Bootstrap — Base System Setup")
        print("=" * 50)
        
        arch_bootstrap = self.bootstrap_dir / "arch.sh"
        return self.run_script(arch_bootstrap, "Arch base system setup")

    def provision_pillar(self, pillar: str, scripts: List[str] = None):
        """Provision a specific pillar (gaming, dev, aesthetic)."""
        pillar_dir = self.pillars_dir / pillar
        
        if not pillar_dir.exists():
            print(f"❌ Pillar not found: {pillar}")
            return False

        print(f"\n🔱 Provisioning Pillar: {pillar.upper()}")
        print("=" * 50)

        # If specific scripts provided, run those; otherwise run all
        if scripts:
            script_paths = [pillar_dir / f"{s}.sh" for s in scripts]
        else:
            script_paths = sorted(pillar_dir.glob("*.sh"))

        success = True
        for script in script_paths:
            if not self.run_script(script):
                success = False
                if not self.confirm_continue():
                    return False
        
        return success

    def provision_from_profile(self, profile_name: str):
        """Provision system based on a YAML profile."""
        print(f"\n🜃 Loading Profile: {profile_name}")
        profile = self.load_profile(profile_name)

        # Load any traits referenced in profile
        traits = profile.get("traits", [])
        for trait in traits:
            trait_data = self.load_trait(trait)
            # Merge trait data into profile (traits are defaults)
            for key, value in trait_data.items():
                if key not in profile:
                    profile[key] = value

        # Run bootstrap if requested
        if profile.get("bootstrap", True):
            if not self.bootstrap():
                if not self.confirm_continue():
                    return False

        # Provision each pillar
        pillars = profile.get("pillars", {})
        for pillar, scripts in pillars.items():
            if not self.provision_pillar(pillar, scripts):
                if not self.confirm_continue():
                    return False

        print("\n✅ Profile provisioning complete!")

    def confirm_continue(self) -> bool:
        """Ask user if they want to continue after an error."""
        response = input("\n⚠️  Continue anyway? [y/N]: ").strip().lower()
        return response == 'y'


def main():
    parser = argparse.ArgumentParser(
        description="MythOS Provisioner — Modular Arch Linux Setup"
    )
    
    parser.add_argument(
        "--profile",
        help="Load a profile YAML (e.g., 'atlas')",
        type=str
    )
    
    parser.add_argument(
        "--bootstrap",
        action="store_true",
        help="Run base Arch bootstrap only"
    )
    
    parser.add_argument(
        "--gaming",
        action="store_true",
        help="Provision gaming pillar"
    )
    
    parser.add_argument(
        "--dev",
        action="store_true",
        help="Provision developer pillar"
    )
    
    parser.add_argument(
        "--aesthetic",
        action="store_true",
        help="Provision aesthetic pillar"
    )

    args = parser.parse_args()

    # Determine repo root
    repo_root = Path(__file__).parent.resolve()
    provisioner = MythOSProvisioner(repo_root)

    # Profile-based provisioning
    if args.profile:
        provisioner.provision_from_profile(args.profile)
        return

    # Manual flag-based provisioning
    if args.bootstrap:
        provisioner.bootstrap()
    
    if args.gaming:
        provisioner.provision_pillar("gaming")
    
    if args.dev:
        provisioner.provision_pillar("developer")
    
    if args.aesthetic:
        provisioner.provision_pillar("aesthetic")

    # If no flags, show help
    if not any([args.profile, args.bootstrap, args.gaming, args.dev, args.aesthetic]):
        parser.print_help()


if __name__ == "__main__":
    main()
