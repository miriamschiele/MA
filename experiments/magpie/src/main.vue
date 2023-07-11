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
      Bitte bewerten Sie nur jeweils die Aussage der Sprecherin B danach, wie natürlich diese Aussage auf Sie wirkt, d. h. ob Sie diese in Ihrem Alltag als akzeptabel empfinden würden oder nicht.
      Denken Sie bitte dabei nicht unbedingt an geschriebene Sprache, sondern an übliche Umgangssprache.
      <br>
      <br>
      Sie können auf einer Skala von <b> 1 (völlig inakzeptabel) </b> bis <b> 7 (völlig akzeptabel) </b> bewerten, für wie akzeptabel sie eine solche Aussage in der Alltagssprache zwischen Muttersprachler:innen finden, d. h. wie natürlich Ihnen diese Aussage vorkommt. Orientieren Sie sich dabei bitte an Ihrem intuitiven Sprachgefühl.
      <br>
      <br>
      Das Bearbeiten des Fragebogens wird etwa 10 Minuten in Anspruch nehmen.
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
      
      Diese Aussage von B entspricht den grammatikalischen Regeln des Deutschen und könnte in der Alltagssprache zwischen Muttersprachler:innen vorkommen.
      Daher wäre eine solche Aussage mit <b> 7 (völlig akzeptabel) </b> zu bewerten.



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
      
      Diese Aussage von B entspricht nicht den Regeln des Deutschen und würde nicht in der
      Alltagssprache eines Muttersprachlers oder einer Muttersprachlerin vorkommen. Daher wäre eine solche
      Aussage mit <b> 1 (völlig inakzeptabel) </b> zu bewerten.





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
      Nachdem Sie auf "Weiter" klicken, beginnt die Studie.
    </InstructionScreen>
    
          <Screen v-if="stimuli == 'auditory' && selectedIndex <= audioFileNames.length" v-for="(audioFile, index) in audioFileNames" :key="index" :validations="{
      answer: {
        minLength: $magpie.v.minLength(5),
        required: $magpie.v.required
      }
    }" :progress= "selectedIndex  / audioFileNames.length">
          <Slide>
            <Record :data="{
          trial_type: audioName(audioFile)[0] == 'C'? 'Critical' : 'Filler',
          fragmentType_Acceptability:  audioName(audioFile)[-2],
          emphasis: audioName(audioFile)[2] == 'O'? 'with' : 'without',
          modality: 'auditory'
        }" />
            
            <b> Ihre Bewertung</b>
            <br>
            <br>
            In der Studie werden Ihnen die Dialoge als Audioaufnahme präsentiert.
            Bitte klicken Sie auf "Start", um den Dialog abspielen zu lassen. 
            <br>
            Wie natürlich wirkt die Aussage der Sprecherin B auf Sie?
            <br>
            <br/>
            <button @click="$refs.audio[0].play()">Start</button>
            <button @click="$refs.audio[0].pause()">Stop</button>
            <audio ref="audio" :src="audioFile" @ended="audioEnded()" />
            <div v-if="audioPlayed">
            <RatingInput quid="Quelle" :right="'völlig akzeptabel'" :left="'völlig inakzeptabel'" 
              :response.sync="$magpie.measurements.response" />
              <button v-if="$magpie.measurements.response" 
              @click="goToNextSlide">Weiter</button>
              <span v-else>Bitte geben Sie eine Bewerung ab.</span>
            </div>
          </Slide>
          </Screen>

          <Screen v-if="stimuli == 'written' && selectedIndex <= sentences.length" v-for="(sentence, index) in sentences" :key="index" :validations="{
      answer: {
        minLength: $magpie.v.minLength(5),
        required: $magpie.v.required
      }
    }" :progress= "selectedIndex/ sentences.length">
          
          <Slide>
            <Record :data="{
          fragmentType_Acceptability: sentence[2],
          trial_type: sentence[1] === 'Filler' ? 'Filler': 'Critical',
          emphasis: sentence[1]=== 'W' ? 'with' : 'without',
          modality: 'written'
        }" />
           
            <b> Ihre Bewertung</b>
            <br>
            <br>
            In der Studie werden Ihnen die Dialoge als Text präsentiert.
            Großbuchstaben stellen dar, welche Wörter von den Sprecher:innen betont werden.
            Bitte lesen Sie sich den Dialog durch. 
            <br>
            Wie natürlich wirkt die Aussage der Sprecherin B auf Sie?
            <br>
            <br>
            {{ sentence[0] }}
            <br>
            {{ sentence[3] }}
            <br>
            <RatingInput quid="Quelle" :right="'völlig akzeptabel'" :left="'völlig inakzeptabel'" 
              :response.sync="$magpie.measurements.response"/>
              <button v-if="$magpie.measurements.response" 
              @click="goToNextSlide">Weiter</button>
              <span v-else>Bitte geben Sie eine Bewertung ab.</span>
          </Slide>
          </Screen>


    <PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>
  
<script>
import _ from 'lodash';
import file from './assets/written_stimuli.txt'

//Import all audio files manually
import CWF1 from "./assets/CWF1-combined.wav";
import CWF2 from "./assets/CWF2-combined.wav";
import CWF3 from "./assets/CWF3-combined.wav";
import CWF4 from "./assets/CWF4-combined.wav";
import CWF5 from "./assets/CWF5-combined.wav";
import CWF6 from "./assets/CWF6-combined.wav";
import CWF7 from "./assets/CWF7-combined.wav";
import CWL1 from "./assets/CWL1-combined.wav";
import CWL2 from "./assets/CWL2-combined.wav";
import CWL3 from "./assets/CWL3-combined.wav";
import CWL4 from "./assets/CWL4-combined.wav";
import CWL5 from "./assets/CWL5-combined.wav";
import CWL6 from "./assets/CWL6-combined.wav";
import CWL7 from "./assets/CWL7-combined.wav";
import CWOF1 from "./assets/CWOF1-combined.wav";
import CWOF2 from "./assets/CWOF2-combined.wav";
import CWOF3 from "./assets/CWOF3-combined.wav";
import CWOF4 from "./assets/CWOF4-combined.wav";
import CWOF5 from "./assets/CWOF5-combined.wav";
import CWOF6 from "./assets/CWOF6-combined.wav";
import CWOF7 from "./assets/CWOF7-combined.wav";
import CWOL1 from "./assets/CWOL1-combined.wav";
import CWOL2 from "./assets/CWOL2-combined.wav";
import CWOL3 from "./assets/CWOL3-combined.wav";
import CWOL4 from "./assets/CWOL4-combined.wav";
import CWOL5 from "./assets/CWOL5-combined.wav";
import CWOL6 from "./assets/CWOL6-combined.wav";
import CWOL7 from "./assets/CWOL7-combined.wav";
import FA1 from "./assets/FA1-combined.wav";
import FA2 from "./assets/FA2-combined.wav";
import FA3 from "./assets/FA3-combined.wav";
import FA4 from "./assets/FA4-combined.wav";
import FA5 from "./assets/FA5-combined.wav";
import FB1 from "./assets/FB1-combined.wav";
import FB2 from "./assets/FB2-combined.wav";
import FB3 from "./assets/FB3-combined.wav";
import FB4 from "./assets/FB4-combined.wav";
import FB5 from "./assets/FB5-combined.wav";
import FB6 from "./assets/FB6-combined.wav";
import FC1 from "./assets/FC1-combined.wav";
import FC2 from "./assets/FC2-combined.wav";
import FC3 from "./assets/FC3-combined.wav";
import FC4 from "./assets/FC4-combined.wav";
import FC5 from "./assets/FC5-combined.wav";
import FC6 from "./assets/FC6-combined.wav";
import FD1 from "./assets/FD1-combined.wav";
import FD2 from "./assets/FD2-combined.wav";
import FD3 from "./assets/FD3-combined.wav";
import FD4 from "./assets/FD4-combined.wav";
import FD5 from "./assets/FD5-combined.wav";
import FD6 from "./assets/FD6-combined.wav";
import FE1 from "./assets/FE1-combined.wav";
import FE2 from "./assets/FE2-combined.wav";
import FE3 from "./assets/FE3-combined.wav";
import FE4 from "./assets/FE4-combined.wav";
import FE5 from "./assets/FE5-combined.wav";





// determine group
const fileContents = file.split(';')
console.log(fileContents)
var sentences = []
while (fileContents.length != 0) {
  if (fileContents[0] == '') {
    break;
  }
  const temp = []
  temp.push(fileContents[0])
  temp.push(fileContents[1])
  temp.push(fileContents[2])
  temp.push(fileContents[3])
  temp.push(fileContents[4])
  temp.push(fileContents[5])
  sentences.push(temp)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
  fileContents.splice(0, 1)
}


sentences = _.shuffle(sentences);
console.log(sentences)
let audioFileNames = [
  CWF1, CWF2, CWF3, CWF4, CWF5, CWF6, CWF7, 
  CWL1, CWL2, CWL3, CWL4, CWL5, CWL6, CWL7, 
  CWOF1, CWOF2, CWOF3, CWOF4, CWOF5, CWOF6, CWOF7, 
  CWOL1, CWOL2, CWOL3, CWOL4, CWOL5, CWOL6, CWOL7, 
  FA1, FA2, FA3, FA4, FA5, 
  FB1, FB2, FB3, FB4, FB5, FB6, 
  FC1, FC2, FC3, FC4, FC5, FC6, 
  FD1, FD2, FD3, FD4, FD5, FD6, 
  FE1, FE2, FE3, FE4, FE5
]
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
        this.selectedIndex++;
        $magpie.saveAndNextScreen()
        this.audioPlayed = false;
        return; // Wrap around to the first item if at the end
    },
    startAudio() {
      this.$refs.audio.play();
    },
    stopAudio() {
      this.$refs.audio.pause();
    },
    audioEnded() {
      this.audioPlayed = true;
    },
    audioName(name) {
      return name.split('-')[0].split('/media/')[1]
    }
  },
  name: 'Main',
  data() {
    return {
      stimuli: stimuli,
      random: Math.random(),
      disableButton: true,
      sentences: sentences,
      audioFileNames: audioFileNames,
      selectedIndex: 0,
      audioPlayed: false
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