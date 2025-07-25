package com.example.kotlin.application.template.di


import com.example.kotlin.application.template.data.InMemoryWeatherStorage
import com.example.kotlin.application.template.data.KtorWeatherApi
import com.example.kotlin.application.template.data.WeatherApi
import com.example.kotlin.application.template.data.WeatherRepository
import com.example.kotlin.application.template.data.WeatherStorage
import com.example.kotlin.application.template.screens.home.HomeViewModel
import io.ktor.client.HttpClient
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.http.ContentType
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.json.Json
import org.koin.core.context.startKoin
import org.koin.core.module.dsl.factoryOf
import org.koin.dsl.module

val dataModule = module {
    single {
        val json = Json { ignoreUnknownKeys = true }
        HttpClient {
            install(ContentNegotiation) {
                json(json, contentType = ContentType.Any)
            }
        }
    }

    single<WeatherApi> { KtorWeatherApi(get()) }
    single<WeatherStorage> { InMemoryWeatherStorage() }
    single {
        WeatherRepository(get(), get()).apply {
            initialize()
        }
    }
}

val viewModelModule = module {
    factoryOf(::HomeViewModel)
}

fun initKoin() {
    startKoin {
        modules(
            dataModule,
            viewModelModule,
        )
    }
}
