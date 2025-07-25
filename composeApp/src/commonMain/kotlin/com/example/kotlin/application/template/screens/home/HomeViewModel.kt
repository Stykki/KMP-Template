package com.example.kotlin.application.template.screens.home

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.kotlin.application.template.data.WeatherRepository
import com.example.kotlin.application.template.data.WeatherResponse
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

class HomeViewModel(private val weatherRepository: WeatherRepository) : ViewModel() {
    val isRefreshing = mutableStateOf(false)

    val reykjavik: StateFlow<WeatherResponse?> =
        weatherRepository.getReykjavik()
            .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), null)

    fun refresh() {
        viewModelScope.launch {
            isRefreshing.value = true
            try {
                weatherRepository.refresh() // Assuming this method exists or needs to be created
            } finally {
                isRefreshing.value = false
            }
        }
    }
}