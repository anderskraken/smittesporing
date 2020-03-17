package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RadioButton
import android.widget.RadioGroup
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_symptoms_step1.view.*
import kotlinx.serialization.UnstableDefault
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

@UnstableDefault
class SymptomsStep1 : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step1, container, false)

        root.step1nextButton.setOnClickListener {
            val input = getUserInput(root)
            if (input != null) {
                val json = Json.toJson(Symptoms.serializer(), input).toString()
                Timber.d("User entered this information: $json")
                val action = SymptomsStep1Directions.actionSymptomsStep1ToSymptomsStep2(json)
                findNavController().navigate(action)
            }
        }

        return root
    }

    private fun getUserInput(root: View): Symptoms? {
        val genderGroup = root.gender_group
        val selectedGender = genderGroup.findViewById<RadioButton>(genderGroup.checkedRadioButtonId)
        val gender = if (selectedGender == null) {
            "null"
        } else {
            selectedGender.text
        }

        val ageInput = root.ageInput.editText?.text.toString()
        val age = try {
            root.ageInput.error = null
            ageInput.toInt()
        } catch (e: NumberFormatException) {
            root.ageInput.error = "Alder må være et gyldig tall"
            return null
        }

        val inRiskGroup = root.riskGroup.getYesOrNoResponse()

        val isTested = root.testedGroup.getYesOrNoResponse()

        return Symptoms(
            gender = gender.toString(),
            age = age,
            inRiskGroup = inRiskGroup,
            testedPositive = isTested
        )
    }
}


fun RadioGroup.getYesOrNoResponse(): Boolean {
    val selected = this.findViewById<RadioButton>(this.checkedRadioButtonId)
    return if (selected == null) {
        false
    } else {
        when (selected.text) {
            "Ja" -> true
            else -> false
        }
    }
}