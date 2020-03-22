package no.agens.covid19.storage.domain

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Location(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "longitude", index = true) val longitude: Double,
    @ColumnInfo(name = "latitude", index = true) val latitude: Double,
    @ColumnInfo(name = "altitude", index = true) val altitude: Double,
    @ColumnInfo(name = "timestamp", index = true) val timestamp: String,
    @ColumnInfo(name = "horizontal_accuracy") val horizontalAccuracy: Float,
    @ColumnInfo(name = "bearing_accuracy") val bearingAccuracy: Float = 0f,
    @ColumnInfo(name = "vertical_accuracy") val verticalAccuracy: Float = 0f
)