włączyć docker buildkit

docker buildx create --name multiarch-builder --use
![Image](https://github.com/user-attachments/assets/1bc4e481-0349-4404-afdf-1efebf3d9590)

docker buildx inspect --bootstrap
![Image](https://github.com/user-attachments/assets/0e9ef3f4-3212-49a5-b120-e5d7eadc89e9)

docker buildx build --platform linux/amd64,linux/arm64 --file Dockerfile_dod --tag adamdawi/weather-app:latest --push --build-arg BUILDKIT_INLINE_CACHE=1 --cache-to=type=registry,ref=adamdawi/weather-app:buildcache,mode=max --cache-from=type=registry,ref=adamdawi/weather-app:buildcache --secret id=GITHUB_TOKEN,src=my_token.txt .
![Image](https://github.com/user-attachments/assets/565920c9-af5e-4b5f-a24a-7f2a4d09d5de)

docker buildx imagetools inspect adamdawi/weather-app:latest
![Image](https://github.com/user-attachments/assets/b038a327-5592-4557-a2ca-2707ed6d1aac)

docker scout cves --platform linux/amd64 adamdawi/weather-app:latest
![Image](https://github.com/user-attachments/assets/74561aa6-5274-45d6-af95-c7bf7f59d38a)

Znaleziona podatność:
Pakiet: cross-spawn@7.0.3

Poziom ryzyka: HIGH (7.5/10)

CVE: CVE-2024-21538

Opis: Inefficient Regular Expression Complexity

Dotknięte wersje: >=7.0.0 i <7.0.5

Poprawiona wersja: 7.0.5

🔧 1. Zaktualizuj zależność cross-spawn:
W swoim projekcie (np. package.json) zmień wersję:

json
Copy
Edit
"cross-spawn": "^7.0.5"

poprawienie dependency cross-spawn
![Image](https://github.com/user-attachments/assets/6c63e099-6e8c-49d2-8b6d-b09878c45766)



ponowne budowanie obrazu:
![Image](https://github.com/user-attachments/assets/f27a32d2-361d-463d-b5f5-911d728eae57)