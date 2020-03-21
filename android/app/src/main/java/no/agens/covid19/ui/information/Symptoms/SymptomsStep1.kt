package no.agens.covid19.ui.information.Symptoms

import android.app.Activity
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.RadioButton
import android.widget.RadioGroup
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.widget.doOnTextChanged
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_symptoms_step1.view.*
import kotlinx.serialization.UnstableDefault
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

@UnstableDefault
class SymptomsStep1 : androidx.fragment.app.Fragment() {

    private lateinit var root: View

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        root = inflater.inflate(R.layout.fragment_symptoms_step1, container, false)

        if (savedInstanceState != null && savedInstanceState.containsKey("userInput")) {
            val userInput = savedInstanceState.get("userInput") as Symptoms
            root.ageInput.editText?.setText(userInput.age.toString())
        }

        root.step1BackButton.setOnClickListener {
            findNavController().popBackStack()
        }

        root.step1nextButton.setOnClickListener {
            val input = getUserInput(root)
            if (input != null) {
                val json = Json.toJson(Symptoms.serializer(), input).toString()
                Timber.d("User entered this information: $json")
                val action = SymptomsStep1Directions.actionSymptomsStep1ToSymptomsStep2(json)
                findNavController().navigate(action)
            }
        }

        root.ageInput?.editText?.doOnTextChanged { text, start, count, after ->
            try {
                text.toString().toInt()
                root.ageInput.error = null
            } catch (e: NumberFormatException) {
                root.ageInput.error = "Alder må være et gyldig tall"
            }
        }

        root.scrollView.setOnScrollChangeListener { view, i, i2, i3, i4 ->
            val imm =
                view.context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
            if (imm.isAcceptingText) {
                imm.hideSoftInputFromWindow(view.windowToken, 0)
            }
        }

        return root
    }

    override fun onSaveInstanceState(outState: Bundle) {
        outState.putSerializable("userInput", getUserInput(root))
        super.onSaveInstanceState(outState)

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