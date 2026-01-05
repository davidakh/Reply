//
//  ResponseGenerator.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import Foundation
import FoundationModels

enum ResponseStyle: String, CaseIterable, Identifiable {
    case professional = "Professional"
    case casual = "Casual"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .professional: return "briefcase"
        case .casual: return "face.smiling"
        }
    }
    
    var instructions: String {
        switch self {
        case .professional:
            return """
            You are a professional email writing assistant.
            Generate professional, polite, and well-structured email responses.
            Use formal language, proper greetings, and professional sign-offs.
            Keep responses concise and business-appropriate.
            """
        case .casual:
            return """
            You are a friendly messaging assistant.
            Generate casual, friendly, and conversational message responses.
            Use informal language and a warm, approachable tone.
            Keep responses brief and natural, like a text message or casual chat.
            """
        }
    }
}

@Observable
class ResponseGenerator {
    var isGenerating = false
    var currentResponse: String = ""
    var errorMessage: String?
    var modelAvailable = false
    
    private let model = SystemLanguageModel.default
    
    init() {
        checkModelAvailability()
    }
    
    func checkModelAvailability() {
        switch model.availability {
        case .available:
            modelAvailable = true
        case .unavailable(.deviceNotEligible):
            errorMessage = "Device not eligible for Apple Intelligence"
        case .unavailable(.appleIntelligenceNotEnabled):
            errorMessage = "Please enable Apple Intelligence in Settings"
        case .unavailable(.modelNotReady):
            errorMessage = "Model is downloading or not ready"
        case .unavailable(let other):
            errorMessage = "Model unavailable: \(other)"
        }
    }
    
    func generateResponse(for input: String, style: ResponseStyle) async {
        guard modelAvailable else {
            errorMessage = "Model not available"
            return
        }
        
        isGenerating = true
        currentResponse = ""
        errorMessage = nil
        
        do {
            // Create a session with style-specific instructions
            let session = LanguageModelSession(instructions: style.instructions)
            
            // Generate the prompt based on the style
            let prompt: String
            switch style {
            case .professional:
                prompt = "Write a professional email response to: \(input)"
            case .casual:
                prompt = "Write a casual, friendly message response to: \(input)"
            }
            
            // Stream the response for a better user experience
            let stream = session.streamResponse(to: prompt)
            
            for try await partial in stream {
                currentResponse = partial.content
            }
            
        } catch {
            errorMessage = "Error generating response: \(error.localizedDescription)"
            currentResponse = ""
        }
        
        isGenerating = false
    }
    
    func retry(for input: String, style: ResponseStyle) async {
        await generateResponse(for: input, style: style)
    }
    
    func clear() {
        currentResponse = ""
        errorMessage = nil
    }
}
