package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.Navigation
import kotlinx.android.synthetic.main.fragment_symptoms.view.*
import kotlinx.android.synthetic.main.fragment_symptoms_step1.view.*
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.*
import no.agens.covid19.R

class SymptomsStep1 : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step1, container, false)

        root.step1nextButton.setOnClickListener(
            Navigation.createNavigateOnClickListener(R.id.action_symptomsStep1_to_symptomsStep2, null)
        )

        return root
    }
}