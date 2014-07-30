namespace :db do

class RandomSubmissionGenerator
	attr_accessor(
		:assessors, 
		:assessment_texts, 
		:possible_scores, 
		:first_names, 
		:last_names,
		:levels,
		:languages,
		:dates
	)

	def initialize(assessors, assessment_texts, possible_scores, first_names, last_names, levels, languages, dates)
		@assessors = assessors
		@assessment_texts = assessment_texts
		@possible_scores = possible_scores
		@first_names = first_names
		@last_names = last_names
		@levels = levels
		@languages = languages
		@dates = dates
	end

	def rand_submission()
		first_name = first_names.sample
		last_name = last_names.sample
		creation_date = dates.sample
		is_active = [true, false].sample

		submission = Submission.create({
			email_text: 'test', 
			candidate_name: first_name + ' ' + last_name, 
			candidate_email: first_name + '.' + last_name + '@example.com',
		    level: levels.sample, 
		    language: languages.sample,
		    active: is_active,
		    created_at: creation_date
		})

		assessments = generate_assessments_for_submission(submission)
		submission.recalculate_average_score
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

  desc "populate the database with randomly generated submissions and assessments"
  task populate: :environment do
	require 'date'

	allRoles = Role.all
	if (allRoles.nil? || allRoles.empty?)
		raise "You must seed the db before it can be populated (rake db:seed)"
		return
	end

	assessorRole = allRoles.find {|role| role.name == 'Assessor'}
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
		'James',
		'Robert',
		'Michael',
		'William',
		'Mary',
		'Patricia',
		'Linda',
		'Maria'
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
		'Smith',
		'Johnson',
		'Williams',
		'Jones',
		'Brown',
		'Davis'
	]

	possible_scores = (1..5).to_a

	today = Date.today()
	months_ago = today << 3
	dates = (months_ago .. today).to_a
	levels = Level.all
	languages = Language.all

	rsg = RandomSubmissionGenerator.new(assessors, assessment_texts, possible_scores, 
		first_names, last_names, levels, languages, dates)
	num_submissions = 60
	submissions = (1..num_submissions).map { 
		rsg.rand_submission()
	}
  end

end
