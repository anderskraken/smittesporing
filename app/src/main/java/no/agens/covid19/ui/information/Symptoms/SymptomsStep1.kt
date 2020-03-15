package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import no.agens.covid19.R

class SymptomsStep1 : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step1, container, false)



        return root
    }

}