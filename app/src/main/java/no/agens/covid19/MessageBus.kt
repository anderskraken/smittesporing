package no.agens.covid19

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer

object MessageBus {

    val bus = MutableLiveData<Message>()


    interface Message

    fun <T : Message> publish(message: T) {
        bus.setValue(message)
    }

    fun observeBus(lifecycleOwner: LifecycleOwner, callback: Observer<Message>) {
        bus.observe(lifecycleOwner, callback)
    }

}