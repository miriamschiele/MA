<template>
    <Experiment title="Study on problem solving">
      <InstructionScreen :title="'Welcome'">
        Herzlich willkommen und vielen Dank, dass Sie an dieser Studie teilnehmen!
  
        <br>
  
        Im Folgenden werden Ihnen kurze Dialoge präsentiert. 
        Die Aussage des Sprechers A dient lediglich dazu, Ihnen den Kontext des Gesprächs verständlich zu machen.
        Bitte bewerten Sie nur jeweils die Aussage der Sprecherin B danach, wie natürlich diese Aussage auf Sie wirkt.
        Denken Sie bitte dabei nicht unbedingt an geschriebene Sprache, sondern an übliche Umgangssprache. 
        Sie können auf einer Skala von 1 (völlig akzeptable) bis 7 (völlig inakzeptabel) bewerten, wie akzeptable Sie die präsentierten Aussagen der Sprecherin B finden. 

        Das Bearbeiten des Fragebogens wird etwa 5 Minuten in Anspruch nehmen.

        Hinweise zur Freiwilligkeit und Datenschutz:
        Ihre Angaben werden vertraulich behandelt.
        Die Auswertungen erfolgen in Übereinstimmung mit den bestehenden Datenschutzgesetzen vollkommen anonym. 
        Die Daten werden dabei so gespeichert, dass jede Rückverfolgung zu persönlichen Informationen ausgeschlossen ist. 
        Mit Abschluss der Studie stimmen Sie zu, dass Ihre Daten in anonymisierter Form zu Forschungszwecken verwendet werden dürfen.
        Die Teilnahme an der Studie ist freiwillig. Sie können jederzeit und ohne Angabe von Gründen die Teilnahme an dieser Studie beenden, ohne dass Ihnen daraus Nachteile entstehen. 
      
         
        
      </InstructionScreen>

      <InstructionScreen :title="'Einführung 1/3'">
        Hinweise zur Bewertungsskala
  
        <br>
  
        Um Ihnen ein klares Verständnis der Bewertungsskala zu vermitteln, die in dieser Studie verwendet wird, präsentieren wir Ihnen drei Beispiele. 
        Bitte lesen Sie das erste Beispiel durch: 

        (1) A: was mag Peter?
            B: Peter mag Ingwer.

            Diese Aussage von B entspricht den grammatikalischen Regeln des Deutschen und könnte sehr wahrscheinlich so in der gesprochenen Sprache im Alltag zwischen Muttersprachler:innen vorkommen. 
            Daher wäre eine solche Aussage mit 1 (völlig akzeptabel) zu bewerten.       
      
         
        
      </InstructionScreen>

      <InstructionScreen :title="'Einführung 2/3'">
        Hinweise zur Bewertungsskala
  
        <br>
  
        Um Ihnen ein klares Verständnis der Bewertungsskala zu vermitteln, die in dieser Studie verwendet wird, präsentieren wir Ihnen drei Beispiele. 
        Bitte lesen Sie das zweite Beispiel durch: 

        (2) A: Was hat Peter gestern gemacht?
            B: Vater Fußball gestern.

        Da diese Aussage von B nicht den Regeln des Deutschen entspricht und sehr unwahrscheinlich so in der gesprochenen Sprache im Alltag eines Muttersprachlers oder einer Muttersprachlerin vorkommen würde, wäre eine solche Aussage mit 7, d. h. völlig inakzeptabel, zu bewerten.


      
         
        
      </InstructionScreen>

      <InstructionScreen :title="'Einführung 3/3'">
        Hinweise zur Bewertungsskala
  
        <br>
  
        Um Ihnen ein vollständiges Verständnis der Bewertungsskala zu vermitteln, präsentieren wir Ihnen ein letztes Beispiel. 
        Bitte lesen Sie das letzte Beispiel durch: 

        (3) A: Hat Peter inzwischen aufgegeben?
            B: Nein, das Handtuch, das würde er bestimmt nie werfen!
        
        Diese Aussage von B ist zwar kein wohlgeformter Satz des Deutschen, aber würde im Alltag eines Muttersprachlers oder einer Muttersprachlerin vermutlich dennoch verstanden werden. 
        Diese Aussage wäre somit -je nach ihrer eigenen Einschätzung- als 4, d. h. weder akzeptabel noch inakzeptabel, zu bewerten.
        
        Die Beispiele sollen Ihnen lediglich einen Überblick über mögliche Dialoge geben. 
        Bitte bewerten Sie die Aussagen von B nach Ihrem intuitiven Gefühl als Muttersprachler:in.

        Nachdem Sie auf "Weiter" klicken, beginnt die Studie.
        
      </InstructionScreen>
  
      <Screen :validations="{
        response: {
          minLength: $magpie.v.minLength(5),
          required: $magpie.v.required
        }
      }">
  
    <Experiment>
      <Screen>

      <Slide>
        This is a dog.<br/>
        <button @click="$refs.audio.play()">Start</button>
        <button @click="$refs.audio.pause()">Stop</button>
        <audio ref="audio" src="audio/dog_bark.ogg" loop />
      </Slide>

    </Screen>

      </Experiment>
  
      </Screen>
  
      
      <Screen :validations="{
        response: {
          required: $magpie.v.required
        }
      }">
        <Slide >
          <Record :data="{
                group: group,
                task: 'acceptability rating'
                }" />
          Please rate the naturalness of speaker B's response.
          <RatingInput quid="Quelle" :right="'völlig inakzeptabel'" :left="'völlig akzeptabel'" :response.sync="$magpie.measurements.response" />
  
          <button v-if="!$magpie.validateMeasurements.response.$invalid" @click="$magpie.saveAndNextScreen()">Submit</button>
  
        </Slide>
      </Screen>
  
       
      <PostTestScreen />
      <SubmitResultsScreen />
    </Experiment>
  </template>
  
  <script>
  import _ from 'lodash';
  // determine group
  var group = _.shuffle(["beast, long vignette", "virus, long vignette", "beast, short vignette", "virus, short vignette"])[0] 
  var backgrounds = {
      "beast, long vignette": "Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500.",
      "virus, long vignette": "Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500.",
      "beast, short vignette": "Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. The rise in violent crime is particularly alarming.",
      "virus, short vignette": "Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. The rise in violent crime is particularly alarming.",
  }
  var background = backgrounds[group]
  console.log(group)
  export default {
    methods: {
      chooseQuestion: function () {
        return this.random;
      },
      randomOption: function () {
        const leftOption = this.options[Math.floor(Math.random() * this.options.length)];
        const rightOption = this.options.find(option => option !== leftOption);
        return [leftOption, rightOption]
      }
    },
    name: 'Replication',
    data() {
      return {
          group: group,
          background: background,
        options: [
          'Reform educational practices and create after school programs',
          'Increase street patrols that look for criminals'
        ],
        random: Math.random(),
        disableButton: true
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