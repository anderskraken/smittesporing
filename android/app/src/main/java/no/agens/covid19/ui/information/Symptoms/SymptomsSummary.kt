package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_symptoms_summary.view.*
import no.agens.covid19.R

class SymptomsSummary : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_summary, container, false)

        root.summarySaveButton.setOnClickListener {
            // TODO: Save details here
            findNavController().popBackStack(R.id.navigation_symptoms, false)
        }

        return root
    }
}