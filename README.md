# Monarch

Monarch — distro Arch-based minimal com Hyprland, repo pacman próprio e instalador Calamares (omarchy mais leve)
Distro Arch-based, rolling release, com Hyprland — do zero ao desktop.

## O que tem

- **Base**: Arch Linux + archiso (perfil estilo releng em `archiso/`)
- **Desktop**: Hyprland + waybar + wofi + mako + foot, tema mínimo azul `#8ab4f8`
- **Áudio**: pipewire + wireplumber
- **Repo pacman próprio**: `monarch` publicado em GitHub Pages (`horizzon3507.github.io/monarch`)
- **Instalador**: Calamares com branding próprio (`archiso/airootfs/etc/calamares`)
- **Apps do repo monarch**: abstract-editor, stillmusic, usagenometer (PKGBUILDs puxados dos repos upstream, definidos em `repo/packages.txt`)

## Build local (precisa de Linux/Arch)

```bash
# 1. builda o repo de pacotes (gera repo/out/x86_64/monarch.db)
sudo pacman -S base-devel pacman-contrib
./repo/build-repo.sh            # precisa rodar como user com sudo, não root puro
```

## Build da ISO (GitHub Actions — recomendado)

O workflow `iso.yml` faz tudo num container Arch:

1. job `repo` — builda os pacotes e publica via GitHub Pages (Actions) — vira o repo pacman
2. job `iso` — roda `mkarchiso` e sobe a ISO como artifact

Precisa do Pages com **Source: GitHub Actions** em Settings → Pages (uma vez).

```bash
gh workflow run iso.yml
# baixar a ISO depois:
gh run download -n monarch-iso
```

## Testar a ISO

```bash
qemu-system-x86_64 -m 4G -enable-kvm -cdrom monarch-*.iso -boot d
# ou sem KVM (mais lento):
qemu-system-x86_64 -m 4G -cdrom monarch-*.iso -boot d
```

Live session: autologin `live`/`live` no tty1 → entra direto no Hyprland.
Instalador: `calamares`.

## Estrutura

```
archiso/            perfil archiso (packages, pacman.conf, profiledef)
  airootfs/         overlay do filesystem (os-release, configs, calamares, skel)
repo/               definição e build do repo pacman `monarch`
.github/workflows/  CI: repo → gh-pages, ISO → artifact
```

## Adicionar pacote ao repo

Edite `repo/packages.txt` (`<nome> <git-url> <dir-do-PKGBUILD>`) — o próximo
run da CI já inclui.

## Renomear

`monarch` aparece em: `archiso/profiledef.sh` (iso_name/label/install_dir),
`pacman.conf` ([monarch] + Server URL), `airootfs/etc/os-release`,
`airootfs/etc/calamares/` (branding + unpackfs path), `repo/build-repo.sh`
(REPO_NAME). Troque junto.
