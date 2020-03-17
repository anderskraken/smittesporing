package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.Navigation
import androidx.navigation.fragment.navArgs
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.*
import kotlinx.serialization.UnstableDefault
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

@UnstableDefault
class SymptomsStep2 : androidx.fragment.app.Fragment() {

    private val args: SymptomsStep2Args by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step2, container, false)

        val receivedSymptomsFromPrevFrag = args.intermediateSymptoms
        val intermediateSymptoms = Json.parse(Symptoms.serializer(), receivedSymptomsFromPrevFrag)
        Timber.d("Got this data from prev fragment: $intermediateSymptoms")

        root.saveButton.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.action_symptomsStep2_to_symptomsStep3, null))

        return root
    }
}
