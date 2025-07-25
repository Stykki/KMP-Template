package com.example.kotlin.application.template.data

import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.utils.io.CancellationException

interface WeatherApi {
    suspend fun getReykjavik(): WeatherResponse?
}

class KtorWeatherApi(private val client: HttpClient): WeatherApi {

    companion object {
        private const val API_URL = "https://api.open-meteo.com/v1"
        private const val FIXED_API_URL = "$API_URL/forecast?latitude=64.15&longitude=21.94&hourly=temperature_2m"
    }

    override suspend fun getReykjavik(): WeatherResponse? {
        return try {
            val location = client.get(FIXED_API_URL).body<WeatherResponse>()

            location
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            null
        }
    }
}