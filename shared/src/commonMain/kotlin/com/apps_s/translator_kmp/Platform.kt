package com.apps_s.translator_kmp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform