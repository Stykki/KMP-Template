package com.example.kotlin.application.template.screens.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.kotlin.application.template.data.WeatherResponse
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun HomeScreen() {
    val viewModel = koinViewModel<HomeViewModel>()
    // Assuming your ViewModel exposes a StateFlow<WeatherResponse?>
    val weatherState = viewModel.reykjavik.collectAsState()

    Box(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        contentAlignment = Alignment.Center
    ) {
        val weather: WeatherResponse? = weatherState.value

        if (weather == null) {
            CircularProgressIndicator()
        } else {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    text = "Weather Forecast",
                    style = MaterialTheme.typography.headlineMedium
                )
                Spacer(modifier = Modifier.height(8.dp))

                // Display timezone for context
                Text(
                    text = "Timezone: ${weather.timezone}",
                    style = MaterialTheme.typography.titleMedium
                )
                Spacer(modifier = Modifier.height(16.dp))

                // Display the most recent hourly temperature, if available
                if (weather.hourly.time.isNotEmpty() && weather.hourly.temperature_2m.isNotEmpty()) {
                    // Assuming the lists are ordered and the last entry is the most current
                    // or the first entry is the most current, depending on your API.
                    // For this example, let's take the first available temperature.
                    val latestTime = weather.hourly.time.first()
                    val latestTemperature = weather.hourly.temperature_2m.first()
                    val temperatureUnit = weather.hourly_units.temperature_2m

                    Text(
                        text = "Current Forecast:",
                        style = MaterialTheme.typography.titleSmall
                    )
                    Text(
                        text = "$latestTemperature${temperatureUnit}",
                        style = MaterialTheme.typography.displayLarge
                    )
                    Text(
                        text = "Time: $latestTime", // You might want to format this time
                        style = MaterialTheme.typography.bodyMedium
                    )
                } else {
                    Text(
                        text = "Hourly forecast data not available.",
                        style = MaterialTheme.typography.bodyMedium
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "Location: Lat ${weather.latitude}, Lon ${weather.longitude}",
                    style = MaterialTheme.typography.bodySmall
                )
                Text(
                    text = "Elevation: ${weather.elevation}m",
                    style = MaterialTheme.typography.bodySmall
                )
            }
        }
    }
}