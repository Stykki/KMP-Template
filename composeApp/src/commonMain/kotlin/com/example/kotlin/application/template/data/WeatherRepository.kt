package com.example.kotlin.application.template.data

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

class WeatherRepository(
    private val weatherApi: WeatherApi,
    private val weatherStorage: WeatherStorage,
) {
    private val scope = CoroutineScope(SupervisorJob())

    fun initialize() {
        scope.launch {
            refresh()
        }
    }

    suspend fun refresh() {
        weatherStorage.saveReykjavik(weatherApi.getReykjavik())
    }

    fun getReykjavik(): Flow<WeatherResponse?> {
        return weatherStorage.getReykjavik()
    }
}
