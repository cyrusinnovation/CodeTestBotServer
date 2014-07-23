# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

levels = Level.create(['Junior', 'Mid', 'Senior', 'Tech Lead'].collect_concat {|l| {text: l}})
languages = Language.create([{name: 'Java'}, {name: 'Ruby'}])
roles = Role.create([{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}])

class RandomSubmissionGenerator
	attr_accessor(
		:assessors, 
		:assessment_texts, 
		:possible_scores, 
		:first_names, 
		:last_names,
		:levels,
		:languages
	)

	def initialize(assessors, assessment_texts, possible_scores, first_names, last_names, levels, languages)
		@assessors = assessors
		@assessment_texts = assessment_texts
		@possible_scores = possible_scores
		@first_names = first_names
		@last_names = last_names
		@levels = levels
		@languages = languages
	end

	def rand_submission()
		first_name = first_names.sample
		last_name = last_names.sample

		submission = Submission.create({
			email_text: 'test', 
			candidate_name: first_name + ' ' + last_name, 
			candidate_email: first_name + '.' + last_name + '@example.com',
	    level: levels.sample, 
	    language: languages.sample,
	    active: [true, false].sample
	  })

		assessments = generate_assessments_for_submission(submission)
		submission.average_score = assessments.reduce(0) {|sum,assess| sum + assess.score} / assessments.length.to_f
		submission.update_attribute(:average_score, submission.average_score)
	end

	def generate_assessments_for_submission(submission)
		(1..rand_num_assessments).map { 
			rand_assessment( assessors.sample, submission, assessment_texts.sample) 
		}
	end

	def rand_num_assessments
		(1 + rand * 3).to_i
	end

	def rand_assessment(assessor, submission, assessment_text)
		Assessment.create({
			submission: submission, 
			assessor: assessor, 
			score: possible_scores.sample, 
			notes: assessment_text
		})
	end
end

# In the development environment, load additional seed data.
if (ENV["RAILS_ENV"] == "development")
		assessorRole = roles.find {|role| role.name == 'Assessor'}
		assessors = Assessor.create([
			{name: 'Bob Berkley', email: 'bb@assessor.com', role: assessorRole},
			{name: 'Christine Chandler', email: 'cc@assessor.com', role: assessorRole},
			{name: 'Don Draper', email: 'dd@assessor.com', role: assessorRole},
			{name: 'Edna Edwards', email: 'ee@assessor.com', role: assessorRole},
			{name: 'Fred Flintstone', email: 'ff@assessor.com', role: assessorRole},
			{name: 'Gail Gladstone', email: 'gg@assessor.com', role: assessorRole}
		])

		assessment_texts = [
			'A great perturbation in nature, to receive at once the benefit of sleep, and do the effects of watching!',
			'It is an accustomed action with her, to seem thus washing her hands: I have known her continue in this a quarter of an hour.',
			'Out, damned spot! out, I say!',
			'Yet who would have thought the old man to have had so much blood in him.',
			'The thane of Fife had a wife: where is she now?',
			'She has spoke what she should not',
			'all the perfumes of Arabia will not sweeten this little hand.',
			'This disease is beyond my practise',
			'Wash your hands, put on your nightgown',
			'To bed, to bed! theres knocking at the gate',
			'Foul whisperings are abroad',
			'Remove from her the means of all annoyance',
			'The English power is near, led on by Malcolm',
			'Near Birnam wood',
			'Great Dunsinane he strongly fortifies',
			'Now minutely revolts upbraid his faith-breach',
			'Meet we the medicine of the sickly weal',
			'Make we our march towards Birnam',
			'Till Birnam wood remove to Dunsinane, I cannot taint with fear',
			'And mingle with the English epicures',
			'Go prick thy face, and over-red thy fear',
			'As honour, love, obedience, troops of friends',
			'Canst thou not minister to a mind diseased',
			'Cleanse the stuffed bosom of that perilous stuff',
			'Throw physic to the dogs',
			'Ill none of it',
			'And purge it to a sound and pristine health',
			'Would scour these English hence?',
			'What rhubarb, cyme, or what purgative drug',
			'I will not be afraid of death and bane',
			'Till Birnam forest come to Dunsinane',
			'Cousins, I hope the days are near at hand',
			'Let every soldier hew him down a bough',
			'That will with due decision make us know'
		]

		first_names = [
			'Justus',
			'Kalliope',
			'Kelby',
			'Kinzly',
			'Kiwi',
			'Kukua',
			'Lovelle',
			'Loveena',
			'Manda',
			'Nyx',
			'Oceana',
			'Pippin',
			'Holmes',
			'Hurricane',
			'Ivory',
			'Jag',
			'Kashmere',
			'Kazz',
			'Kodiak',
			'Lalo',
			'Legend',
			'Leviathan',
			'Lorcan',
			'Miggy',
		]

		last_names = [
			'Sida',
			'Trixie',
			'Tulip',
			'Viggo',
			'Wrigley',
			'Xaviera',
			'Zabrina',
			'Zelia',
			'Zona',
			'Osbaldo',
			'Panda',
			'Ripley',
			'Rocket',
			'Stetson',
			'Thiago',
			'Thirdy',
			'Tintin',
			'Trace',
			'Yash',
			'Zion',
		]

		possible_scores = (1..5).to_a

		rsg = RandomSubmissionGenerator.new(assessors, assessment_texts, possible_scores, 
			first_names, last_names, levels, languages)
		num_submissions = 35
		submissions = (1..num_submissions).map { 
			rsg.rand_submission()
		}
end
