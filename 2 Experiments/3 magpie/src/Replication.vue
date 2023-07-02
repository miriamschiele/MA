<template>
  <Experiment title="Study on dialogues">
    <InstructionScreen :title="'Willkommen'">
      <div style="font-weight: bold;">
        Herzlich willkommen und vielen Dank, dass Sie an dieser Studie teilnehmen!
      </div>


      <br>

      Im Folgenden werden Ihnen kurze Dialoge zwischen zwei Personen A und B präsentiert.
      <br>
      <br>
      Die Aussage des Sprechers A dient lediglich dazu, Ihnen den Kontext des Gesprächs verständlich zu machen.
      Bitte bewerten Sie nur jeweils die Aussage der Sprecherin B danach, wie natürlich diese Aussage auf Sie wirkt.
      Denken Sie bitte dabei nicht unbedingt an geschriebene Sprache, sondern an übliche Umgangssprache.
      <br>
      <br>
      Sie können auf einer Skala von <b> 1 (völlig akzeptabel) </b> bis <b> 7 (völlig inakzeptabel) </b> bewerten, wie
      natürlich Sie die präsentierten Aussagen der Sprecherin B finden.
      <br>
      <br>
      Das Bearbeiten des Fragebogens wird etwa 5 Minuten in Anspruch nehmen.
      <br>
      <br>
      <br>
      <div style="font-weight: bold;">
        Hinweise zur Freiwilligkeit und Datenschutz
      </div>
      <br>
      Ihre Angaben werden vertraulich behandelt.
      Die Auswertungen erfolgen in Übereinstimmung mit den bestehenden Datenschutzgesetzen vollkommen anonym.
      Die Daten werden dabei so gespeichert, dass jede Rückverfolgung zu persönlichen Informationen ausgeschlossen ist.
      <br>
      Mit Abschluss der Studie stimmen Sie zu, dass Ihre Daten in anonymisierter Form zu Forschungszwecken verwendet
      werden dürfen.
      Die Teilnahme an der Studie ist freiwillig. Sie können jederzeit und ohne Angabe von Gründen die Teilnahme an dieser
      Studie beenden, ohne dass Ihnen daraus Nachteile entstehen.



    </InstructionScreen>

    <InstructionScreen :title="'Einführung 1/3'">
      <div style="font-weight: bold;">
        Hinweise zur Bewertungsskala
      </div>

      <br>

      Um Ihnen ein klares Verständnis der Bewertungsskala zu vermitteln, die in dieser Studie verwendet wird, präsentieren
      wir Ihnen drei Beispiele.
      Bitte lesen Sie das <b>erste Beispiel</b> durch:
      <br>
      <br>

      (1) A: Was mag Peter?
      <br>
      <div style="margin-left: 25px;">
        B: Peter mag Ingwer.
      </div>

      <br>
      <br>
      Diese Aussage von B entspricht den grammatikalischen Regeln des Deutschen und könnte sehr wahrscheinlich so in der
      gesprochenen Sprache im Alltag zwischen Muttersprachler:innen vorkommen.
      Daher wäre eine solche Aussage mit <b> 1 (völlig akzeptabel) </b> zu bewerten.



    </InstructionScreen>

    <InstructionScreen :title="'Einführung 2/3'">
      <div style="font-weight: bold;">
        Hinweise zur Bewertungsskala
      </div>
      <br>

      Um Ihnen ein klares Verständnis der Bewertungsskala zu vermitteln, die in dieser Studie verwendet wird, präsentieren
      wir Ihnen drei Beispiele.
      Bitte lesen Sie das <b>zweite Beispiel</b> durch:
      <br>
      <br>

      (2) A: Was hat Peter gestern gemacht?
      <br>
      <div style="margin-left: 25px;">
        B: Vater Fußball gestern.
      </div>

      <br>
      <br>

      Diese Aussage von B entspricht nicht den Regeln des Deutschen und würde sehr unwahrscheinlich so in der gesprochenen
      Sprache im Alltag eines Muttersprachlers oder einer Muttersprachlerin nicht vorkommen. Daher wäre eine solche
      Aussage mit <b> 7 (völlig inakzeptabel) </b> zu bewerten.





    </InstructionScreen>

    <InstructionScreen :title="'Einführung 3/3'">
      <div style="font-weight: bold;">
        Hinweise zur Bewertungsskala
      </div>
      <br>

      Um Ihnen ein vollständiges Verständnis der Bewertungsskala zu vermitteln, präsentieren wir Ihnen ein letztes
      Beispiel.
      Bitte lesen Sie das <b>letzte Beispiel</b> durch:
      <br>
      <br>
      (3) A: Hat Peter inzwischen aufgegeben?
      <br>
      <div style="margin-left: 25px;">
        B: Nein, das Handtuch, das würde er bestimmt nie werfen!
      </div>

      <br>
      <br>

      Diese Aussage von B ist zwar kein wohlgeformter Satz des Deutschen, aber würde im Alltag eines Muttersprachlers oder
      einer Muttersprachlerin vermutlich dennoch verstanden werden.
      Diese Aussage wäre somit -je nach ihrer eigenen Einschätzung- als <b> 3, 4 oder 5 (weder akzeptabel noch
        inakzeptabel) </b> zu bewerten.
      <br>
      <br>
      Die Beispiele sollen Ihnen lediglich einen Überblick über mögliche Dialoge geben.
      Bitte bewerten Sie die Aussagen von B nach Ihrem intuitiven Gefühl als Muttersprachler:in.
      <br>
      <br>
      In der Studie werden Ihnen die Dialoge entweder als Text oder als Audioaufnahme präsentiert.
      <br>
      <br>
      Nachdem Sie auf "Weiter" klicken, beginnt die Studie.

    </InstructionScreen>
    <Screen :validations="{
      response: {
        minLength: $magpie.v.minLength(5),
        required: $magpie.v.required
      }
    }">


      <div v-if="stimuli == 'auditory'">
        <div v-for="(audioFile, index) in audioFileNames" :key="index">
          <Slide v-if="index === selectedIndex">
          {{ audioFile }}<br />
          <button @click="$refs.audio[index].play()">Start</button>
          <button @click="$refs.audio[index].pause()">Stop</button>
          <audio ref="audio" :src="audioFile" loop />
        </Slide>
        </div>
        
      </div>

      <div v-if="stimuli == 'written'">
        <div v-for="(sentence, index) in sentences" :key="index">
          
          <Slide v-if="index === selectedIndex">
            {{selectedIndex}}
            {{ sentence[0] }}
            <br>
            {{ sentence[1] }}
            <br>
            <RatingInput quid="Quelle" :right="'völlig inakzeptabel'" :left="'völlig akzeptabel'"
          :response.sync="$magpie.measurements.response" />
            <button @click="goToNextSlide">Next slide</button>

            </Slide>
        </div>
        

      </div>



    </Screen>

    <Screen :validations="{
      response: {
        required: $magpie.v.required
      }
    }">
      <Slide>
        <Record :data="{
          task: 'acceptability rating'
        }" />
        Please rate the naturalness of speaker B's response.
        <RatingInput quid="Quelle" :right="'völlig inakzeptabel'" :left="'völlig akzeptabel'"
          :response.sync="$magpie.measurements.naturalness" />

        <button v-if="!$magpie.validateMeasurements.response.$invalid"
          @click="$magpie.saveAndNextScreen()">Submit</button>

      </Slide>
    </Screen>


    <PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>
  
<script>
import _ from 'lodash';
import file from './assets/wF.txt'
// determine group
const fileContents = file.split(';')
var sentences = []
while (fileContents.length != 0) {
  if (fileContents[0] == '') {
    break;
  }
  const temp = []
  temp.push(fileContents[0])
  temp.push(fileContents[1])
  sentences.push(temp)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
}


sentences = _.shuffle(sentences);
const audioFiles = require.context(
  '@/assets',
  true,
  /^.*\.wav$/
)
let audioFileNames = audioFiles.keys();
audioFileNames = audioFileNames.map(file  => { return file.replace('.','./assets')});
audioFileNames = _.shuffle(audioFileNames);

var stimuli = _.shuffle(['written', 'auditory'])[0]



export default {
  methods: {
    chooseQuestion: function () {
      return this.random;
    },
    randomOption: function () {
      const leftOption = this.options[Math.floor(Math.random() * this.options.length)];
      const rightOption = this.options.find(option => option !== leftOption);
      return [leftOption, rightOption]
    },
    goToNextSlide() {
      const listType = this.stimuli == 'written' ? this.sentences: this.audioFileNames
      if (this.selectedIndex < this.listType.length - 1) {
        this.selectedIndex++;
      } else {
        $magpie.saveAndNextScreen()
        return; // Wrap around to the first item if at the end
      }
    }
  },
  name: 'Replication',
  data() {
    return {
      options: [
        'Reform educational practices and create after school programs',
        'Increase street patrols that look for criminals'
      ],
      stimuli: stimuli,
      random: Math.random(),
      disableButton: true,
      sentences: sentences,
      audioFileNames: audioFileNames,
      selectedIndex: 0
    };
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  }
};
</script>