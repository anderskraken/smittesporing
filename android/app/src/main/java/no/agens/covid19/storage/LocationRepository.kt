package no.agens.covid19.storage

import android.content.Context
import androidx.room.*
import no.agens.covid19.storage.domain.Location
import timber.log.Timber

class LocationRepository(context: Context) {

    private val database: LocationDatabase

    init {
        database =
            Room.databaseBuilder(context, LocationDatabase::class.java, "location_db").build()
    }

    @Database(entities = [Location::class], version = 1)
    abstract class LocationDatabase : RoomDatabase() {
        abstract fun locationDao(): LocationDao
    }

    @Dao
    interface LocationDao {

        @Insert
        fun insert(location: Location)

        @Query("SELECT * FROM Location ORDER BY datetime(timestamp) DESC LIMIT 1")
        fun fetchLast(): Location
    }

    fun addLocations(location: Location) {
        database.locationDao().insert(location)
        Timber.d("New location added to database: $location")
    }

    fun getLast(): Location = database.locationDao().fetchLast()
}