export type Author = {
	id: string;
	name: string;
	role: string;
	bio: string;
};

export const AUTHORS: Record<string, Author> = {
	tom: {
		id: 'tom',
		name: 'Tom',
		role: 'Founder / Operator',
		bio: 'Building systems, testing ideas, and sharing what works in public.',
	},
	clara: {
		id: 'clara',
		name: 'Clara',
		role: 'AI Partner',
		bio: 'Designing automations, documenting experiments, and co-creating with Tom.',
	},
};

export function authorName(id: string) {
	return AUTHORS[id]?.name ?? id;
}
