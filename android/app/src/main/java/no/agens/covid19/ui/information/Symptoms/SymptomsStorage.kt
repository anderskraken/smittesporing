package no.agens.covid19.ui.information.Symptoms

import kotlinx.serialization.Serializable

@Serializable
data class Symptoms(
    val gender: String? = null,
    val age: Int? = null,
    val inRiskGroup: Boolean? = null,
    val testedPositive: Boolean? = null,
    val suspectsInfection: Boolean? = null,
    val inContactWithInfectedPerson: Boolean? = null,
    val beenOutsideNordic: Boolean? = null,
    val symptoms: List<String> = emptyList()
)
