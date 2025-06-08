package com.apps_s.translator_kmp.voice_to_text.domain

import com.apps_s.translator_kmp.core.domain.util.CommonFlow

data class VoiceToTextParserState(
    val result: String = "",
    val error: String? = null,
    val powerRatio: Float = 0f,
    val isSpeaking: Boolean = false
)
