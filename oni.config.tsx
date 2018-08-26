import * as React from "react"
import * as Oni from "oni-api"

interface ISidebar {
    sidebar: {
        activeEntryId: string
        isFocused: boolean
    }
}


export const activate = (oni: Oni.Plugin.Api) => {
    const isNormalMode = () => oni.editors.activeEditor.mode === "normal"

    // Input
    oni.input.bind("g-d", () => "language.gotoDefinition", isNormalMode)
    oni.input.unbind("<F3>")
    oni.input.bind("<F1>", () => "terminal.openInVerticalSplit", isNormalMode )

    oni.input.bind(["<enter>", "<tab>"], "contextMenu.next");

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}


export const configuration = {
    "acheivements.enabled": false,
    "experimental.markdownPreview.enabled": true,
    "experimental.versionControl.enabled":true,
    "experimental.vcs.sidebar": true,
    "editor.fontFamily": "Iosevka",
    "editor.renderer": "webgl",
    "editor.fontSize": "13px",
    "editor.typingPrediction": true,
    "editor.completions.mode": 'oni',
    "editor.textMateHighlighting.enabled": false,
    "editor.quickOpen.execCommand": "git ls-files | fzf > result",
    "learning.enabled": false,
    "language.rust.languageServer.rootFiles": ["Cargo.toml"],
    "oni.useDefaultConfig": false,
    "oni.loadInitVim":  true,
    "oni.useExternalPopupMenu":true,
    "oni.hideMenu": true,
    "oni.exclude": ["**/node_modules/**", "**/lib/**", ".git"],
    "oni.enhancedSyntaxHighlighting": false,
    "sidebar.enabled": true,
    "sidebar.default.open": false,
    "sidebar.with": "8rem",
    "statusbar.enabled": false,
    "tabs.mode": "buffers",
    // "language.rust.languageServer.command": "rustup",
    // "language.rust.languageServer.arguments": ["run", "nightly", "rls"],
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",
    "ui.colorscheme": "n/a",
    "workspace.defaultWorkspace": false,
    //"oni.bookmarks": ["~/Documents"],
    }
