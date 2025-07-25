package com.example.kotlin.application.template.data


import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

interface WeatherStorage {
    suspend fun saveReykjavik(rvk: WeatherResponse)
    fun getReykjavik(): Flow<WeatherResponse?>
}

class InMemoryWeatherStorage : WeatherStorage{
    private val storedReykjavik = MutableStateFlow<WeatherResponse?>(null)

    override suspend fun saveReykjavik(rvk: WeatherResponse) {
        storedReykjavik.value = rvk
    }

    override fun getReykjavik(): Flow<WeatherResponse?> {
        return storedReykjavik
    }
}
