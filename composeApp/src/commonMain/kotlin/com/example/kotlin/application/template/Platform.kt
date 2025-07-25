package com.example.kotlin.application.template

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform