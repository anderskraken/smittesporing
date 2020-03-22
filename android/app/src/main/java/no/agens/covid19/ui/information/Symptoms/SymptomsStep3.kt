package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.Navigation
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_symptoms.view.*
import kotlinx.android.synthetic.main.fragment_symptoms_step1.view.*
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.*
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.saveButton
import kotlinx.android.synthetic.main.fragment_symptoms_step3.view.*
import no.agens.covid19.R

class SymptomsStep3 : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step3, container, false)

        root.saveButton.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.action_symptomsStep3_to_symptomsSummary, null))
        root.step3BackButton.setOnClickListener {
            findNavController().popBackStack()
        }

        return root
    }
}