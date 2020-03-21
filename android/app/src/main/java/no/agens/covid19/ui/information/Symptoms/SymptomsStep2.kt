package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.ContextMenu
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import androidx.fragment.app.FragmentManager
import androidx.navigation.Navigation
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.google.android.material.datepicker.CalendarConstraints
import com.google.android.material.datepicker.MaterialDatePicker
import com.google.android.material.textfield.TextInputLayout
import kotlinx.android.synthetic.main.fragment_symptoms_step2.view.*
import kotlinx.serialization.UnstableDefault
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber
import java.text.SimpleDateFormat
import java.time.Instant
import java.util.*

@UnstableDefault
class SymptomsStep2 : androidx.fragment.app.Fragment() {

    private val args: SymptomsStep2Args by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms_step2, container, false) as ConstraintLayout

        val receivedSymptomsFromPrevFrag = args.intermediateSymptoms
        val intermediateSymptoms = Json.parse(Symptoms.serializer(), receivedSymptomsFromPrevFrag)
        Timber.d("Got this data from prev fragment: $intermediateSymptoms")

        if (intermediateSymptoms.testedPositive == true) {
            hideSuspectInfectionField(root)
        }

        hideLastContactField(root)
        root.contactGroup.contactGroupYes.setOnCheckedChangeListener { compoundButton, checked ->
            if (checked) {
                showLastContactField(root)
            } else {
                hideLastContactField(root)
            }
        }

        hideBackToNorwayField(root)
        root.outsideNorwayGroup.outsideNorwayGroupYes.setOnCheckedChangeListener { compoundButton, checked ->
            if (checked) {
                showBackToNorwayField(root)
            } else {
                hideBackToNorwayField(root)
            }
        }



        root.lastContactInput.setupDatePicker(parentFragmentManager) { selectedDate ->

        }

        root.backToNorwayInput.setupDatePicker(parentFragmentManager) { selectedDate: Date ->

        }

        root.saveButton.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.action_symptomsStep2_to_symptomsStep3, null))
        root.step2BackButton.setOnClickListener {
            findNavController().popBackStack()
        }

        return root
    }

    private fun showLastContactField(root: ConstraintLayout) {
        root.lastContact.visibility = View.VISIBLE
        root.lastContactInput.visibility = View.VISIBLE
        ConstraintSet().apply {
            clone(root.scrollView2.innerConstraints)
            connect(root.outsideNorwayLabel.id, ConstraintSet.TOP, root.lastContactInput.id, ConstraintSet.BOTTOM)
            connect(root.outsideNorwayLabel.id, ConstraintSet.START, root.lastContactInput.id, ConstraintSet.START)
            connect(root.outsideNorwayLabel.id, ConstraintSet.END, root.lastContactInput.id, ConstraintSet.END)
            applyTo(root.scrollView2.innerConstraints)
        }
    }

    private fun hideLastContactField(root: ConstraintLayout) {
        root.lastContact.visibility = View.GONE
        root.lastContactInput.visibility = View.GONE
        ConstraintSet().apply {
            clone(root.scrollView2.innerConstraints)
            connect(root.outsideNorwayLabel.id, ConstraintSet.TOP, root.contactGroup.id, ConstraintSet.BOTTOM)
            connect(root.outsideNorwayLabel.id, ConstraintSet.START, root.contactGroup.id, ConstraintSet.START)
            connect(root.outsideNorwayLabel.id, ConstraintSet.END, root.contactGroup.id, ConstraintSet.END)
            applyTo(root.scrollView2.innerConstraints)
        }
    }


    private fun showBackToNorwayField(root: ConstraintLayout) {
        root.backToNorway.visibility = View.VISIBLE
        root.backToNorwayInput.visibility = View.VISIBLE
//        ConstraintSet().apply {
//            clone(root.scrollView2.innerConstraints)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.TOP, root.backToNorwayInput.id, ConstraintSet.BOTTOM)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.START, root.backToNorwayInput.id, ConstraintSet.START)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.END, root.backToNorwayInput.id, ConstraintSet.END)
//            applyTo(root.scrollView2.innerConstraints)
//        }
    }

    private fun hideBackToNorwayField(root: ConstraintLayout) {
        root.backToNorway.visibility = View.GONE
        root.backToNorwayInput.visibility = View.GONE
//        ConstraintSet().apply {
//            clone(root.scrollView2.innerConstraints)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.TOP, root.contactGroup.id, ConstraintSet.BOTTOM)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.START, root.contactGroup.id, ConstraintSet.START)
//            connect(root.outsideNorwayLabel.id, ConstraintSet.END, root.contactGroup.id, ConstraintSet.END)
//            applyTo(root.scrollView2.innerConstraints)
//        }
    }

    private fun hideSuspectInfectionField(root: ConstraintLayout) {
        root.suspectInfectionQuestion.visibility = View.GONE
        root.suspectInfectionGroup.visibility = View.GONE
        ConstraintSet().apply {
            clone(root.scrollView2.innerConstraints)
            connect(root.contactLabel.id, ConstraintSet.TOP, root.subtitle.id, ConstraintSet.BOTTOM)
            connect(root.contactLabel.id, ConstraintSet.START, root.subtitle.id, ConstraintSet.START)
            connect(root.contactLabel.id, ConstraintSet.END, root.subtitle.id, ConstraintSet.END)
            applyTo(root.scrollView2.innerConstraints)
        }
    }
}

private fun TextInputLayout.setupDatePicker(fragmentManager: FragmentManager, onDateSelectedCallback: (Date) -> Unit) {
    editText?.isFocusableInTouchMode = false
    editText?.setOnClickListener {
        showDatePicker(this, fragmentManager, onDateSelectedCallback)
    }
    setEndIconOnClickListener {
        showDatePicker(this, fragmentManager, onDateSelectedCallback)
    }
}

fun showDatePicker(textInputLayout: TextInputLayout, fragmentManager: FragmentManager, onDateSelectedCallback: (Date) -> Unit) {
    val now = Calendar.getInstance().timeInMillis
    val oneYearAgo = Calendar.getInstance()
    oneYearAgo.set(Calendar.YEAR, 2019)
    val calendarConstraints = CalendarConstraints.Builder()
        .setStart(oneYearAgo.timeInMillis)
        .setEnd(now)
        .build()
    val picker = MaterialDatePicker.Builder.datePicker()
        .setTitleText(R.string.select_date)
//        .setInputMode(MaterialDatePicker.INPUT_MODE_CALENDAR)
        .setCalendarConstraints(calendarConstraints)
        .build()

    picker.addOnPositiveButtonClickListener {
        val date = Date(it)
        textInputLayout.helperText = ""
        textInputLayout.editText?.setText(SimpleDateFormat("d. MMMM").format(date))
        onDateSelectedCallback(date)
    }
    picker.showNow(fragmentManager, "DatePicker")
}
