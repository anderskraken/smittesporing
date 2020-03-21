package no.agens.covid19.ui.information.Symptoms

import kotlinx.serialization.*
import java.util.*

@Serializable
data class Symptoms(
    var gender: String? = null,
    var age: Int? = null,
    var inRiskGroup: Boolean? = null,
    var testedPositive: Boolean? = null,
    var suspectsInfection: Boolean? = null,
    var inContactWithInfectedPerson: Boolean? = null,
    @Serializable(with = DateSerializer::class) var lastContact: Date? = null,
    var beenOutsideNordic: Boolean? = null,
    @Serializable(with = DateSerializer::class) var backToNorway: Date? = null,
    var symptoms: MutableList<String> = mutableListOf()
) : java.io.Serializable

@Serializer(forClass = Date::class)
object DateSerializer : KSerializer<Date> {
    override val descriptor: SerialDescriptor =
        PrimitiveDescriptor("DateSerializer", PrimitiveKind.STRING)

    override fun serialize(output: Encoder, obj: Date) {
        output.encodeString(obj.time.toString())
    }

    override fun deserialize(input: Decoder): Date {
        return Date(input.decodeString().toLong())
    }
}
