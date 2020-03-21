package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.FragmentManager
import androidx.navigation.Navigation
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
        val root = inflater.inflate(R.layout.fragment_symptoms_step2, container, false)

        val receivedSymptomsFromPrevFrag = args.intermediateSymptoms
        val intermediateSymptoms = Json.parse(Symptoms.serializer(), receivedSymptomsFromPrevFrag)
        Timber.d("Got this data from prev fragment: $intermediateSymptoms")

        root.lastContactInput.setupDatePicker(parentFragmentManager) { selectedDate ->

        }

        root.backToNorwayInput.setupDatePicker(parentFragmentManager) { selectedDate: Date ->

        }

        root.saveButton.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.action_symptomsStep2_to_symptomsStep3, null))

        return root
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
