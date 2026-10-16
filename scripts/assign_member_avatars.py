import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MEMBERS_PATH = ROOT / "assets" / "data" / "members.json"

AVATAR_BY_PARISH = {
    "Allen": "assets/images/avatars/img_avatar1.png",
    "Catarman": "assets/images/avatars/img_avatar1.png",
    "Gamay": "assets/images/avatars/img_avatar1.png",
    "Las Navas": "assets/images/avatars/img_avatar1.png",
    "Mondragon": "assets/images/avatars/img_avatar1.png",
    "San Antonio": "assets/images/avatars/img_avatar1.png",
    "San Vicente": "assets/images/avatars/img_avatar1.png",
    "Biri": "assets/images/avatars/img_avatar2.png",
    "Catubig": "assets/images/avatars/img_avatar2.png",
    "Hibubullao": "assets/images/avatars/img_avatar2.png",
    "Lavezares": "assets/images/avatars/img_avatar2.png",
    "Pambujan": "assets/images/avatars/img_avatar2.png",
    "San Isidro": "assets/images/avatars/img_avatar2.png",
    "Silvino Lobos": "assets/images/avatars/img_avatar2.png",
    "Bobon": "assets/images/avatars/img_avatar3.png",
    "Cawayan": "assets/images/avatars/img_avatar3.png",
    "Laoang": "assets/images/avatars/img_avatar3.png",
    "Lope De Vega": "assets/images/avatars/img_avatar3.png",
    "Polangi": "assets/images/avatars/img_avatar3.png",
    "San Jose": "assets/images/avatars/img_avatar3.png",
    "Uep": "assets/images/avatars/img_avatar3.png",
    "Capul": "assets/images/avatars/img_avatar4.png",
    "Dalakit": "assets/images/avatars/img_avatar4.png",
    "Lapinig": "assets/images/avatars/img_avatar4.png",
    "Mapanas": "assets/images/avatars/img_avatar4.png",
    "Rosario": "assets/images/avatars/img_avatar4.png",
    "San Roque": "assets/images/avatars/img_avatar4.png",
    "Victoria": "assets/images/avatars/img_avatar4.png",
}

DEFAULT_AVATAR = "assets/images/avatars/img_avatar1.png"


def pick_avatar(parish: str) -> str:
    return AVATAR_BY_PARISH.get(parish.strip(), DEFAULT_AVATAR)


def main() -> None:
    data = json.loads(MEMBERS_PATH.read_text(encoding="utf-8"))
    members = data["members"]
    unknown = set()
    for member in members:
        parish = member["parishMunicipality"]
        asset = pick_avatar(parish)
        if parish.strip() not in AVATAR_BY_PARISH:
            unknown.add(parish)
        member["avatarAsset"] = asset
    MEMBERS_PATH.write_text(
        json.dumps(data, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(f"Updated {len(members)} members with parish-based avatarAsset.")
    if unknown:
        print("Unknown parishes (used default avatar 1):")
        for name in sorted(unknown):
            print(f"  - {name}")


if __name__ == "__main__":
    main()
