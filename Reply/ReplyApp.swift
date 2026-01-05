//
//  ReplyApp.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import SwiftUI
import AppKit

@main
struct ReplyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem?
    var floatingPanel: FloatingPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Make this a menu bar only app (no dock icon)
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            updateStatusItemImage()
            button.action = #selector(togglePanel)
            button.target = self
        }
        
        // Observe appData changes to update icon
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatusItemImage),
            name: NSNotification.Name("UpdateMenuIcon"),
            object: nil
        )
    }
    
    private func createPanelIfNeeded() {
        guard floatingPanel == nil else { return }
        
        // Create floating panel lazily when first needed
        floatingPanel = FloatingPanel(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 500),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        floatingPanel?.delegate = self
        floatingPanel?.contentView = NSHostingView(
            rootView: ContentView()
                .frame(width: 280)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        )
    }
    
    @objc func togglePanel() {
        // Create panel on first use
        createPanelIfNeeded()
        
        guard let panel = floatingPanel, let button = statusItem?.button else { return }
        
        if panel.isVisible {
            panel.orderOut(nil)
            NSApp.hide(nil)
        } else {
            // Position panel below menu bar icon
            let buttonRect = button.window?.convertToScreen(button.convert(button.bounds, to: nil)) ?? .zero
            let panelX = buttonRect.midX - panel.frame.width / 2
            let panelY = buttonRect.minY - panel.frame.height - 8
            
            panel.setFrameOrigin(NSPoint(x: panelX, y: panelY))
            
            // Activate the app and show panel
            NSApp.activate(ignoringOtherApps: true)
            panel.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc func updateStatusItemImage() {
        if let button = statusItem?.button {
            // Use system image (SF Symbol)
            if let image = NSImage(systemSymbolName: "text.bubble.fill", accessibilityDescription: nil) {
                image.isTemplate = true // Adapts to menu bar appearance
                let resizedImage = NSImage(size: NSSize(width: 18, height: 18))
                resizedImage.lockFocus()
                image.draw(in: NSRect(x: 0, y: 0, width: 18, height: 18))
                resizedImage.unlockFocus()
                resizedImage.isTemplate = true
                button.image = resizedImage
            }
        }
    }
    
    func windowDidResignKey(_ notification: Notification) {
        floatingPanel?.orderOut(nil)
    }
}

class FloatingPanel: NSPanel {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.level = .popUpMenu
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        
        // Enable layer and set corner radius
        self.contentView?.wantsLayer = true
        self.contentView?.layer?.cornerRadius = 28
        self.contentView?.layer?.masksToBounds = false
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}

