# Assembly Game Project - Windows 32-bit

## 專案結構
```
project/
├── src/            # 源代碼檔案
│   ├── main.asm       # 主程式進入點
│   ├── input.asm      # 輸入處理
│   ├── display.asm    # 顯示功能
│   ├── game_logic.asm # 遊戲邏輯
│   ├── boss.asm       # Boss 戰鬥系統
│   ├── delay.asm      # 延遲和時間功能
│   └── math.asm       # 數學運算
├── data/           # 資料檔案
│   ├── constants.asm  # 常數定義
│   ├── strings.asm    # 字串資源
│   └── levels.asm     # 關卡資料
├── obj/            # 目標檔案 (編譯產生)
├── bin/            # 執行檔 (編譯產生)
├── compile.bat     # 編譯腳本
└── clean.bat       # 清理腳本
```
#1117更新版（待定）
src/
│── main.asm            → 程式進入點 + 大流程控制
│── menu.asm            → 開始遊戲 / 選關 / 難度選擇
│── display.asm         → 顯示 + 顏色 + 字型
│── input.asm           → 輸入 A/D/Enter
│── delay.asm           → 時間控制
│── math.asm            → 所有效果運算
│── arrows.asm          → 箭數系統（已做好一半）
│── round.asm           → 回合系統（10 回合）
│── boss.asm            → Boss 對決
│── levels.asm          → 多關配置（每關不同 +1 / ×2）
│── ui.asm              → 視覺元素（框線 / 進度條）
│── fx.asm              → 動畫（箭數上升特效）
│── sound.asm           → 聲音（加分用，簡單 beep）
└── random.asm          → 隨機化效果（+1, +3, ×2 隨機）

## 系統需求
- Windows 作業系統 (32-bit 或 64-bit)
- Microsoft Visual Studio 或 Visual Studio Build Tools
- MASM (Microsoft Macro Assembler) - 包含在 Visual Studio 中

## 安裝 MASM
1. 開啟 Visual Studio Installer
2. 點選「修改」
3. 在「個別元件」標籤中搜尋 "MASM"
4. 勾選「MSVC v143 - VS 2022 C++ x64/x86 的 MASM」
5. 套用變更

## 編譯說明

### 方法 1: 使用批次檔
```batch
# 編譯專案
compile.bat

# 清理編譯檔案
clean.bat
```

### 方法 2: 使用開發人員命令提示字元
1. 開啟「Developer Command Prompt for VS 2022」
2. 導航到專案目錄
3. 執行 `compile.bat`

### 方法 3: 手動編譯
```batch
# 編譯單一檔案
ML /c /coff /Zi src\main.asm

# 連結所有檔案
LINK /INCREMENTAL:no /debug /subsystem:console /entry:start /out:bin\game.exe obj\*.obj kernel32.lib user32.lib
```

## 執行遊戲
```batch
bin\game.exe
```

## 遊戲控制
- **方向鍵** - 移動角色
- **A** - 向左選擇
- **D** - 向右選擇
- **Space** - 攻擊
- **ESC** - 暫停/選單
- **Enter** - 確認

## 程式碼說明

### 主要模組

#### main.asm
- 程式進入點 (`start`)
- 初始化系統
- 顯示歡迎畫面
- 呼叫遊戲主迴圈

#### input.asm
- 處理鍵盤輸入
- 支援同步和非同步輸入
- 方向鍵和按鍵偵測

#### display.asm
- 控制台顯示功能
- 游標控制
- 顏色設定
- 文字輸出

#### game_logic.asm
- 遊戲主迴圈
- 玩家移動
- 敵人 AI
- 碰撞偵測
- 分數計算

#### boss.asm
- Boss 戰鬥系統
- 戰鬥動畫
- 回合制戰鬥

#### delay.asm
- 時間控制
- FPS 限制
- 動畫延遲

#### math.asm
- 數學運算
- 隨機數生成
- 基本運算函數

### 資料檔案

#### constants.asm
- 遊戲常數定義
- 螢幕大小
- 遊戲狀態值

#### strings.asm
- 所有遊戲文字
- 選單文字
- 錯誤訊息

#### levels.asm
- 關卡資料
- 敵人配置
- Boss 屬性

## 除錯
使用 Visual Studio 或 WinDbg 進行除錯：
1. 編譯時已包含除錯資訊 (`/Zi` 和 `/debug`)
2. 使用 Visual Studio 開啟 `bin\game.exe`
3. 設定中斷點並執行

## 常見問題

### 'ml' 不是內部或外部命令
- 確認已安裝 MASM
- 使用 Developer Command Prompt
- 或手動設定 PATH 環境變數

### 連結錯誤
- 確認所有 .asm 檔案都已編譯成 .obj
- 檢查函數名稱是否正確（注意 @n 後綴）
- 確認 PUBLIC 和 EXTERN 宣告一致

### 程式當機
- 檢查堆疊平衡（push/pop 配對）
- 確認暫存器保護
- 檢查陣列邊界

## 擴展建議
1. 加入音效支援 (使用 winmm.lib)
2. 改善圖形顯示 (使用更多 ASCII 藝術)
3. 增加更多關卡
4. 實作存檔功能
5. 加入多人模式

## 授權
教育用途，自由使用和修改。

## 作者
Assembly Game Project Team

## 版本
v1.0 - Windows 32-bit Edition
