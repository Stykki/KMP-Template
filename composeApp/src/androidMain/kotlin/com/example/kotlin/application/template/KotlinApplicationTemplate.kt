package com.example.kotlin.application.template

import android.app.Application
import com.example.kotlin.application.template.di.initKoin

class KotlinApplicationTemplate: Application() {
    override fun onCreate() {
        super.onCreate()
        initKoin()
    }
}

