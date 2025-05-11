# 🎮 Nintendo Switch スクリーンショット自動バックアップシステム

Nintendo SwitchをRaspberry PiにUSB接続するだけで、自動でスクリーンショット・動画をバックアップする仕組みです。

## 必要なもの

- Raspberry Pi　(Raspberry Pi OS Desktop版を推奨)
- データ転送対応USBケーブル
- Nintendo Switch本体
- 以下のパッケージをインストール

```bash
sudo apt update
sudo apt install libglib2.0-bin
```

> `libglib2.0-bin`は`gio copy`コマンドを使うために必要です。

## インストール手順

### 1. ファイルを配置

以下のファイルをそれぞれ配置します。

- `switch_copy.sh` → `~/switch_copy.sh`
- `switch_monitor.sh` → `~/switch_monitor.sh`
- `switch_monitor.service` → `~/.config/systemd/user/switch_monitor.service`

(`.config/systemd/user/`ディレクトリがない場合は作成してください)

```bash
mkdir -p ~/.config/systemd/user
```

### 2. スクリプトに実行権限を付与

```bash
chmod +x ~/switch_copy.sh
chmod +x ~/switch_monitor.sh
```

### 3. systemdにサービス登録

```bash
systemctl --user daemon-reload
systemctl --user enable switch_monitor.service
systemctl --user start switch_monitor.service
```

これでRaspberry Pi起動時に自動で監視が始まります。

---

## 使い方

1. Raspberry Piを起動します。
2. Nintendo SwitchをUSBケーブルで接続し、「PC接続モード」に切り替えます。
3. 接続すると、自動でスクリーンショット・動画が `~/switch_screenshots/`にバックアップされます。

---

## 注意事項

- Switch本体設定 → 「データ管理」→「画面写真と動画の管理」→「USB接続でパソコンにコピー」を選択してください。
- Raspberry Piにはデスクトップ環境が必要です (gvfsマウントのため)
- Switchを接続した時点で `/run/user/1000/gvfs/`以下にマウントポイントが作成される必要があります。

---

## トラブルシューティング

- **Switchを挿してもコピーが始まらない**
  - `/run/user/1000/gvfs/`内にSwitchがマウントされているか確認してください。

```bash
ls /run/user/1000/gvfs/
```

- **systemdサービスの状態確認**

```bash
systemctl --user status switch_monitor.service
```

エラーが出ている場合は、パス設定などを見直してください。

---

## 📋 switch_monitor.service ファイル内容参考

```ini
[Unit]
Description=Switch Backup Monitor
After=default.target

[Service]
ExecStart=/home/pi/switch_monitor.sh
Restart=always

[Install]
WantedBy=default.target
```
