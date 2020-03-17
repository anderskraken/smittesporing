package no.agens.covid19

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer

sealed class Message
object LocationAccessGranted : Message()
object RequestLocationPermissions : Message()

object MessageBus {

    private val bus = MutableLiveData<Message>()

    fun <T : Message> publish(message: T) {
        bus.setValue(message)
    }

    fun onBusChanged(lifecycleOwner: LifecycleOwner, callback: (Message?) -> Unit) {
        bus.observe(lifecycleOwner, Observer { callback(bus.value) })
    }

}