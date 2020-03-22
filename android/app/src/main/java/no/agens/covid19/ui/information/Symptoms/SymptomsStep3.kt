package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.CompoundButton
import androidx.core.view.children
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.saveButton
import kotlinx.android.synthetic.main.fragment_symptoms_step3.view.*
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

class SymptomsStep3 : androidx.fragment.app.Fragment() {

    private val args: SymptomsStep3Args by navArgs()
    private lateinit var intermediateSymptoms: Symptoms

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step3, container, false)

        val receivedSymptomsFromPrevFrag = args.intermediateSymptoms
        intermediateSymptoms =
            Json.parse(Symptoms.serializer(), receivedSymptomsFromPrevFrag)
        Timber.d("Got this data from prev fragment: $intermediateSymptoms")

        val onSymptomCheckedListener: (CompoundButton, Boolean) -> Unit = { button, checked ->
            val buttonText = button.text.toString()
            if (checked) {
                intermediateSymptoms.symptoms.add(buttonText)
            } else {
                intermediateSymptoms.symptoms.remove(buttonText)
            }
        }

        root.symptomsGroup.children.forEach { it as CheckBox
            it.setOnCheckedChangeListener(onSymptomCheckedListener)
        }

        root.saveButton.setOnClickListener {
            val json = Json.toJson(Symptoms.serializer(), intermediateSymptoms).toString()
            Timber.d("User entered this information: $json")
            val action = SymptomsStep3Directions.actionSymptomsStep3ToSymptomsSummary(json)
            findNavController().navigate(action)
        }
        root.step3BackButton.setOnClickListener {
            findNavController().popBackStack()
        }

        return root
    }
}