package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import kotlinx.android.synthetic.main.fragment_symptoms_summary.view.*
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

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

        root.summarySaveButton.setOnClickListener {
            // TODO: Save details here
            findNavController().popBackStack(R.id.navigation_symptoms, false)
        }

        return root
    }
}