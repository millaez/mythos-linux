#!/usr/bin/env python3
"""Complete theme manager with full translations"""

class ThemeManager:
    THEMES = {
        'greek': {
            'name': 'Greek (Olympian)',
            'banner': '🏛️',
            'pillars': {
                'gaming': {'name': 'Ares', 'title': 'God of War', 'symbol': '⚔️'},
                'developer': {'name': 'Hephaestus', 'title': 'God of the Forge', 'symbol': '🔨'},
                'aesthetic': {'name': 'Aphrodite', 'title': 'Goddess of Beauty', 'symbol': '✨'}
            },
            'actions': {
                'install': 'Summon',
                'configure': 'Enchant',
                'verify': 'Consult the Oracle'
            }
        },
        'norse': {
            'name': 'Norse (Valhalla)',
            'banner': '⚔️',
            'pillars': {
                'gaming': {'name': 'Thor', 'title': 'God of Thunder', 'symbol': '⚡'},
                'developer': {'name': 'Odin', 'title': 'The All-Father', 'symbol': '📚'},
                'aesthetic': {'name': 'Freya', 'title': 'Goddess of Beauty', 'symbol': '✨'}
            },
            'actions': {
                'install': 'Summon',
                'configure': 'Forge',
                'verify': 'Consult the Norns'
            }
        },
        'egyptian': {
            'name': 'Egyptian (Pharaoh)',
            'banner': '𓀭',
            'pillars': {
                'gaming': {'name': 'Horus', 'title': 'God of War', 'symbol': '🦅'},
                'developer': {'name': 'Thoth', 'title': 'God of Wisdom', 'symbol': '📖'},
                'aesthetic': {'name': 'Hathor', 'title': 'Goddess of Beauty', 'symbol': '💎'}
            },
            'actions': {
                'install': 'Consecrate',
                'configure': 'Inscribe',
                'verify': 'Consult the Sphinx'
            }
        }
    }
    
    def __init__(self, theme_name=None):
        self.theme = self.THEMES.get(theme_name, {})
        self.theme_name = theme_name
    
    def get_pillar_info(self, pillar):
        """Get full pillar information with theme"""
        if not self.theme:
            return {'name': pillar.capitalize(), 'symbol': '⚪'}
        return self.theme['pillars'].get(pillar, {})
    
    def translate_action(self, action):
        """Translate action to themed term"""
        if not self.theme:
            return action
        return self.theme['actions'].get(action, action)
    
    def print_banner(self):
        """Print full themed banner"""
        if self.theme:
            banner = self.theme['banner']
            name = self.theme['name']
            print(f"\n{banner} MythOS - {name} Edition {banner}")
            
            # Show pillar gods
            print("\nYour Divine Patrons:")
            for pillar, info in self.theme['pillars'].items():
                print(f"  {info['symbol']} {info['name']} - {info['title']}")
            print()
        else:
            print("\n🏛️ MythOS Provisioner\n")
