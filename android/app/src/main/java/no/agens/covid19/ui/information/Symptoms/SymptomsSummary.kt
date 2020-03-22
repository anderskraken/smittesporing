package no.agens.covid19.ui.information.Symptoms

import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.DrawableRes
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.google.android.material.chip.Chip
import kotlinx.android.synthetic.main.fragment_symptoms_summary.view.*
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber
import java.text.SimpleDateFormat
import java.util.*

class SymptomsSummary : androidx.fragment.app.Fragment() {

    private val args: SymptomsSummaryArgs by navArgs()
    private lateinit var symptoms: Symptoms

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_summary, container, false)

        val receivedSymptomsFromPrevFrag = args.intermediateSymptoms
        symptoms = Json.parse(Symptoms.serializer(), receivedSymptomsFromPrevFrag)
        Timber.d("Got this data from prev fragment: $symptoms")

        root.setHeaderInfo(symptoms)
        root.summaryText1.text = buildAboutYouText(symptoms)
        root.summaryText2.text = buildInfectionSourcesText(symptoms)
        if (symptoms.symptoms.size > 0) {
            root.symptoms_chips.visibility = View.VISIBLE
            root.summaryText3.visibility = View.GONE
            symptoms.symptoms.forEach {
                val chip = Chip(root.context).apply {
                    text = it
                    setTextColor(resources.getColor(R.color.white, context.theme))
                    setChipBackgroundColorResource(R.color.button_blue)
                    iconStartPadding = 4.dpToPx().toFloat()
                }
                root.symptoms_chips.addView(chip)
            }
        } else {
            root.symptoms_chips.visibility = View.GONE
            root.summaryText3.visibility = View.VISIBLE
            root.summaryText3.text = getString(R.string.none)
        }


        root.summarySaveButton.setOnClickListener {
            // TODO: Save details here
            findNavController().popBackStack(R.id.navigation_symptoms, false)
        }

        return root
    }

    private fun buildInfectionSourcesText(symptoms: Symptoms): String {
        val inContactWithInfectedText = if (symptoms.inContactWithInfectedPerson == true) {
            getString(R.string.summary_in_contact_with_infected_info)
        } else {
            getString(R.string.summary_in_contact_with_infected_not_info)
        }
        val beenOutsideNordicText = if (symptoms.beenOutsideNordic == true) {
            getString(R.string.summary_been_outside_nordic_info)
        } else {
            getString(R.string.summary_been_outside_nordic_not_info)
        }

        return """
            • $inContactWithInfectedText
            • $beenOutsideNordicText
        """.trimIndent()
    }

    private fun buildAboutYouText(symptoms: Symptoms): String {
        val gender = if (symptoms.gender in listOf(
                getString(R.string.gender_female),
                getString(R.string.gender_male)
            )
        ) {
            symptoms.gender + ","
        } else {
            ""
        }
        val age = "${symptoms.age} ${getString(R.string.years)}"
        val inRiskGroupText = if (symptoms.inRiskGroup == true) {
            getText(R.string.summary_in_risk_group)
        } else {
            getText(R.string.summary_in_risk_group_not)
        }

        val infected = if (symptoms.testedPositive == true) {
            getText(R.string.summary_infected_info)
        } else {
            getText(R.string.summary_infected_not_info)
        }

        val line1 = "$gender $age, $inRiskGroupText"
        return """
            • $line1
            • $infected
        """.trimIndent()
    }
}

private fun View.setHeaderInfo(symptoms: Symptoms) {
    val headerContent = if (symptoms.symptoms.size >= 3) { // Magic number decided by M.D. Kasin
        HeaderContent(
            text = "Dine symptomer kan tyde på at du er smittet av COVID-19.",
            icon = R.drawable.warning
        )
    } else {
        if (symptoms.beenOutsideNordic == true) {
            val cal = Calendar.getInstance()
            cal.time = symptoms.backToNorway ?: Date()
            cal.add(Calendar.DATE, 14)
            val modDate = cal.time
            val dateAsText = SimpleDateFormat("d. MMMM").format(modDate)
            HeaderContent(
                text = "Du må holde deg i hjemmekarantene frem til og med $dateAsText.",
                icon = R.drawable.ic_home
            )
        } else {
            HeaderContent(
                text = "Hold avstand til andre for å unngå å bli smittet.",
                icon = R.drawable.thumbs_up
            )
        }
    }
    this.summaryIcon.setImageDrawable(context.getDrawable(headerContent.icon))
    this.summarySubtitle.text = headerContent.text
}

private data class HeaderContent(
    val text: String,
    @DrawableRes val icon: Int
)

typealias DP = Int
typealias PX = Int

fun DP.dpToPx(): PX {
    return (this * android.content.res.Resources.getSystem().displayMetrics.density).toInt()
}